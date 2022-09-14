# tokenswap

synopsis:-
Create a project for swapping any token for another token. The user selects the token he/she wants to provide for the swap and the token he/she wants to receive by specifying the contract addresses. After each swap, the address of the user, the swapped token, and the received token should be stored in a mapping.

Assumption:-

-All tokens are equal. So we can swap x amounts of tokenA for x amounts of tokenB as it wasn't mentioned to take specific type of tokens (like ERC20) so I didn't use any token interface and just directly mapped the address of tokens with their amounts.

-Here swapping is done between user and smart contract. So user gives its x token of tokenA to the contract and takes x token of tokenB from the smart contract.
