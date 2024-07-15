// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
  address payable public recipient;
  uint256 public balance;

  error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

  event Deposit(uint256 amount);
  event Withdraw(uint256 amount);

  // Stores a simple transaction struct (type and amount)
  struct Transaction {
    string txType;
    uint256 amount;
  }

  // Array to store transactions (limited functionality)
  Transaction[] public transactions;

  constructor(uint initBalance) payable {
    recipient = payable(msg.sender);
    balance = initBalance;
  }

  function getBalance() public view returns (uint256) {
    return balance;
  }

  function deposit(uint256 _amount) public payable {
    uint _previousBalance = balance;

    balance += _amount;

    assert(balance == _previousBalance + _amount);

    emit Deposit(_amount);

    // Add deposit transaction to history
    transactions.push(Transaction("Deposit", _amount));
  }

  function withdraw(uint256 _withdrawAmount) public {
    uint _previousBalance = balance;
    if (balance < _withdrawAmount) {
      revert InsufficientBalance({
        balance: balance,
        withdrawAmount: _withdrawAmount
      });
    }

    balance -= _withdrawAmount;

    assert(balance == (_previousBalance - _withdrawAmount));

    emit Withdraw(_withdrawAmount);

    // Add withdrawal transaction to history
    transactions.push(Transaction("Withdrawal", _withdrawAmount));
  }

  // Function to retrieve transactions
  function getTransactions() public view returns (Transaction[] memory) {
    return transactions;
  }
}
