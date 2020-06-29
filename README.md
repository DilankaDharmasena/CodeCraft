# CodeCraft

https://apps.apple.com/us/app/CodeCraft/id1450591915

CodeCraft is an iOS app for middle school to high school age children interested in learning how to code.
CodeCraft offers a learning environment that is both narrow enough to ease the convoluted process of learning to code
while also not taking on a childish tone like that of Scratch. Users are able to tackle coding puzzles in a language
similar to Python (making the knowledge gained easily transferable), while also not having to set up their own
programming environments. Think of this app as a very easy LeetCode if LeetCode had a click to code interface.

The app also features a walkthrough mode that allows users to step through their code like a debugger.

## Language Internals

The simple blocks that the user snaps together are translated to Swift internally.

Representation:
    
    [[Operation1, [Input1, Input2, ... , InputN]] , [Operation2, [Input1, Input2, ... , InputN]], ...]

Operations:

   1. {Brackets indicate the possible inputs}
   2. mOP_ID = math operation id (+, -, ...)
   3. cOP_ID = comparison operation id (<, >, ...)

   - SET {VAR, val_type, VAR or NUM or MATH, var_exists}
   - MATH {mOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
   - COMP {cOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
   - IF {COMP, [Operations], comp_exists}
   - FOR {val_type, VAR or NUM or MATH, [Operations]}
   - WHILE {COMP, [Operations], comp_exists}
   - SUBMIT {val_type, VAR or NUM or MATH}
   - Blank
   - Num
   - Var

Notes:

   - Infinite loops are automatically detected and terminated
