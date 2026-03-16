contract LoopExample {

    function sumNumbers(uint n) public pure returns(uint) {

        uint sum = 0;

        for(uint i = 1; i <= n; i++) {
            sum += i;
        }

        return sum;
    }
}

// while loop: runs while a condition is true

function countDown(uint n) public pure returns(uint) {

    uint count = 0;

    while (n>0) {
        count++;
        n--;
    }

    return count;
}

// break: stops the loop immediately

function findNumber(uint[] memory nums, uint target) public pure returns(bool) {

    for (uint i = 0; i < nums.length; i++) {

        if(nums[i] == target) {
            return true;
        }

        if(nums[i] > 100) {
            break;
        }

    }

    return false;
}

// continue: skips the current iteration and moves to the next

function sumEven(uint[] memory nums) public pure returns(uint) {

    uint sum = 0;

    for(uint i = 0; i < nums.length; i++) {

        if(nums[i] % 2 != 0) {
            continue;
        }

        sum += nums[i];
    }

    return sum;
}