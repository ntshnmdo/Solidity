/*
Execution Order + Risks

# What is a Modifier?
A modifier is a reusable piece of code that:
Runs before and/or after a function
Adds restrictions or logic
Avoids repeating code
*/

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _; // continue with the function
}

/*
the _ represents: 
"insert the function body here"
*/

/*
Execution Order of Modifiers

This is critical
when you call a function with a modifier:
*/

function withdraw() public onlyOwner {
    // function body
}

/*
Execution flow:
1. modifier code before _
2. function body
3. modifier code after _ (if exists) 

example with before and after

modifier testModifier() {
    emit Log("Before");
    _;
    emit Log("After");
}

Function:

function execute() public testModifier {
    emit Log("Function");
}

execution order:

id="cx4v6f"

Before
Function
After

Modifier wrapps the function

## Multiple Modifiers execution order
if multiple modifiers exists:

function withdraw() public onlyOwner nonReentrant whenNotPaused {
}

Execution Order:
1. OnlyOwner
2. nonReentrant
3. whenNotPaused
4. function body
5. reverse unwinding (if post-logic exists)

modifiers executes left to right.

# Mental Model
Think of modifier as wrapping layers:

id = "6smmt8"

Modifier1(
    Modifier2(
        Function
    )
)

 This is nested wrapping

# Advanced Modifier Example

modifier costs(uint256 amount) {
    require(msg.value >= amount, "Not enough ETH");
    _;
    if(msg.value > amount) {
        payable(msg.sender).transfer(msg.value - amount);
    }
}

This modifier:
-Checks payment before
-executes function
-refunds excess after

Modifier Logic can exist before and after _.
*/

/*
Common Modifier Patterns

Access Control:

modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}

Reentrancy Guard:

modifier nonReentrant() {
    require(!locked);
    locked = true;
    _;
    locked = false;
}

Prevents reentrancy attacks

Pausable pattern:

modifier whenNotPaused() {
    require(!paused);
    _;
}
*/

/*
Risks of Modifiers

Risk 1: Hidden Control Flow
Modifiers hide logic from main function.

Bad Readability:
function withdraw() public onlyOwner nonReentrant costs(1 ether) {

}

the real logic is scattered 
auditors must inspect modifier carefully.

Risk 2: Reentrancy Vulnerability
If modifier modifies the state incorrectly:

bad pattern:

modifier vulnerable() {
    _;
    locked = false; // dangerous if placed wrongly
}

if state reset happens too late -> vulnerability.
always reset locks After external calls.

Risk 3: Multiple _ usage
A modifier can use _ more than once:

modifier weird() {
    _;
    _;
}

function body executes twice.
this can cause severe bugs.

Risk 4: state changes before fucntion
Bad modifier:

modifier changeState() {
    counter++;
    _;
}

if function reverts, state already changed.
always validate before modifying state.

Risk 5: Reentrancy through external calls

if modifier performs external call BEFORE function:

modifier unsafe() {
    externalContract.call(...);
    _;
}

External call before state change = dangerous
follow checks-effects-interaction pattern.
*/

/*
Best Practices for Safe Modifiers
✅ Keep modifiers simple
Do not put complex logic.

✅ Only do checks before _
Avoid heavy logic after _.

✅ Avoid external calls inside modifiers
Safer to keep in function body.

✅ Avoid modifying state before validation
✅ Prefer internal functions if logic becomes complex

Sometimes this is better:

function withdraw() public {
    _onlyOwner();
}

Internal functions are clearer than deep modifiers.
*/
