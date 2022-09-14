// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


/**
 * @title TokenSwap
   @author Ritik Dhasmana  (ritikdhasmana22@gmail.com)
 * @dev Contract for swaping tokens from one token to another token
  */
contract TokenSwap{
    address _owner;

     /**
     * @dev Set contract deployer as owner
     */
    constructor(){
        _owner = msg.sender;
    }

    /**
     * @dev swap transaction structure
     * @param user  address of user who swapped toknes
     * @param fromToken  address of token that user gave for transaction
     * @param toToken address of token that user wants in return 
     * @param amount  amount of fromToken that the user gave for transaction
     */
    struct swapTransaction{
        address user;
        address fromToken;
        address toToken;
        uint amount;
    }
    //keeping track of all swapping transactions done.
    mapping(address=>swapTransaction[]) public allSwapTransactions;
    
    //amount a person holds of a particular token 
    mapping(address => mapping(address=>uint)) amountPerToken;
    

    //event for when a user does a transaction.
    event swapTransactionDone(
        address user,
        address fromToken,
        address toToken,
        uint amount
        );

    //event for when user deposits token.
    event tokenDeposited(
        address user,
        address token,
        uint amount
        );
     
     /*
     * @dev deposit token to smart contract
     * @param amount the amount user wants to deposit
     * @param address of the token user wants to deposit
     */
    function deposit(uint amount, address tokenAddress) public {
        require(balance(msg.sender,tokenAddress)>=amount,"User doesn't have enough balance.");
        subtractTokens(msg.sender,tokenAddress,amount);
        addTokens(address(this),tokenAddress,amount);
        emit tokenDeposited(msg.sender,tokenAddress,amount);
    }

     /**
     * @dev swaps token
     * @param amount the amount of token to be swapped
     * @param from  address of tokens given by user to be swapped
     * @param to  address of tokens user wants in return
     */
    function swapTokens(uint amount, address from, address to) public {
        require(balance(msg.sender,from)>=amount,"User doesn't have enough balance.");
        require(balance(address(this),to)>=amount,"Not enough tokens in the pool!");

        subtractTokens(msg.sender,from,amount);
        addTokens(address(this),from,amount);

        subtractTokens(address(this),to,amount);
        addTokens(msg.sender,to,amount);

        swapTransaction memory swapT;
        swapT.user = msg.sender;
        swapT.fromToken = from;
        swapT.toToken = to;
        swapT.amount = amount;
        allSwapTransactions[msg.sender].push(swapT);
        emit swapTransactionDone(swapT.user,swapT.fromToken, swapT.toToken,swapT.amount);
    }

    



    /*##########################    Helper Function    ################################*/

    // @dev shows balance of a user 
    function balance(address user, address tokenAddress) public view returns (uint){
        return amountPerToken[user][tokenAddress];
    }

    // @dev increments token count of a user
    function addTokens(address to, address tokenAddress, uint amount)private{
        amountPerToken[to][tokenAddress] = amountPerToken[to][tokenAddress] + amount;
    }

    // @dev decrements token count of a user
    function subtractTokens(address to, address tokenAddress, uint amount)private{
        amountPerToken[to][tokenAddress] = amountPerToken[to][tokenAddress] - amount;
    }

    // @dev mint tokens 
    // @param tokenAddress address of token to be minted
    // @param amount the amount of token to be minted
    function mintTokens(address tokenAddress, uint amount)public{
        amountPerToken[msg.sender][tokenAddress] = amountPerToken[msg.sender][tokenAddress] + amount;
    }

}
