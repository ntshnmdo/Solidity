// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// user defined value types
type Duration is uint64; // time duration

type Timestamp is uint64; // block timestamps

type Clock is uint128; // stores both duration and timestamp together.

library LibClock { // library store reusable functions
    function wrap(Duration _duration, Timestamp _timestamp)
        internal // callable inside contract or derived contracts
        pure // doesnot read or modify blockchain state
        returns (Clock clock_) // returns Clock
    {
        assembly {  // starts inline assembly, assembly used for gas efficiency and bit manipulation
        // data | duration | timestamp
        // bit  | 0....63  | 64....127   
        // 128 bits total = 64 duration and 64 timestamp
            clock_ := or(shl(0x40, _duration), _timestamp) // this packs duration and timestamp into one variable
        // 0x40 = 64 in hex
        // shift duration 64 bits to the left
        // or operation: combines both values into a single uint128, duration and timestamp
        }
    }

    function duration(Clock _clock) // extract duration from the packed clock
        internal
        pure 
        returns (Duration duration_)
    {
        assembly {
            duration_ := shr(0x40, _clock) // shift clock right by 64 bits to get duration, timestamp disappear)
        }
    }

    function timestamp(Clock _clock) // extract the timestamp
        internal
        pure
        returns (Timestamp timestamp_)
    {
        assembly {
            timestamp_ := shr(0xC0, shl(0xC0, _clock)) // this isolates the lower 64 bits, 0xC0 = 192, moves timestamp to the top
        }
    }
}

// clock library without user defined value type

library LibClockBasic {
    function wrap(uint64 _duration, uint64 _timestamp) 
        internal
        pure 
        returns (uint128 clock)
    {
        assembly {
            clock := or (shl(0x40, _duration), _timestamp)
        }
    }
}

contract Examples {
    function example_no_uvdt() external { 
        // without UDVT
        uint128 clock;
        uint64 d = 1;
        uint64 t = uint64(block.timestamp); // get the current block timestamp
        clock = LibClockBasic.wrap(d, t);
        clock = LibClockBasic.wrap(t, d);
    }

    function example_uvdt() external {
        // turn value type into user defined value type
        Duration d = Duration.wrap(1);
        Timestamp t = Timestamp.wrap(uint64(block.timestamp)); // wraps timestamp
        // turn user defined value type back into primitive value type
        uint64 d_u64 = Duration.unwrap(d); // converts back to primitive
        uint64 t_u54 = Timestamp.unwrap(t);

        // libClock example
        Clock clock = Clock.wrap(0); // creates empty clock
        clock = LibClock.wrap(d, t);
    }
}

// without UDVT, compiler cant detect mistakes 
// with UDVT, compiler prevents wrong parameter order.

