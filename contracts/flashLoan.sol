pragma solidity ^0.8.0;

contract FlashLoan {
    address payable public lender;
    address payable public borrower;
    uint256 public loanAmount;
    uint256 public interestRate;
    uint256 public loanDuration;
    bool public loanActive;

    constructor(address payable _lender, address payable _borrower, uint256 _loanAmount, uint256 _interestRate, uint256 _loanDuration) public {
        lender = _lender;
        borrower = _borrower;
        loanAmount = _loanAmount;
        interestRate = _interestRate;
        loanDuration = _loanDuration;
        loanActive = true;
    }

    function repayLoan() public payable {
        require(msg.sender == borrower, "Borrower must repay loan");
        require(loanActive, "Loan is not active");

        uint256 totalRepayment = loanAmount + (loanAmount * interestRate / 100);

        require(msg.value == totalRepayment, "Incorrect repayment amount");

        lender.transfer(totalRepayment);
        loanActive = false;
    }

    function cancelLoan() public {
        require(msg.sender == lender, "Only lender can cancel loan");
        require(loanActive, "Loan is not active");

        loanActive = false;
    }
}
