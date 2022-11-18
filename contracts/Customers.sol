// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Customers {
  constructor() public {
  }

  address[] internal customerList;
  mapping(address => Types.Customer) internal customers;

  // events

  event CustomerAdded(address id_, string name, string email);
  event CustomerDataUpdated(address id_, string name, string email);
  event DataHashUpdated(address id_, string customerName, string dataHash);


  // modifiers

  modifer isValidCustomer(address id_) {
    require(id_ != address(0), "ID is empty");
    require(customer[id_].id_ != address(0), "User ID is empty");
    require(!Helpers.compareStrings(customers[id_].email, ""), "User email is empty");
    _;
  }

  // Helper functions

  function customerExists(address id_) internal view returns (bool exists_) {
    require(id_ != address(0), "Id is empty");
    if (customers[id_].id_ != address(0) && !Helpers.compareStrings(customers[id_].email, "")) {
      exists_ = true;
    }
  }


  // Contract function
  function getCustomerDetials(address id_) internal view returns (Types.Customer memory) {
    return customers[id_];
  }

  function updateProfile(string memory name_, string memory email_, uint256 mobile_) internal {
    customers[msg.sender].name = name_;
    customers[msg.sender].email = email_;
    customers[msg.sender].mobile = mobile_;
    emit CustomerDataUpdated(msg.sender, name_, email_);
  }

  function addCustomer(Types.Customer memory customer_) internal {
    customers[customer_.id_] = customer_;
    customerList.push(customer_.id_);
    emit CustomerAdded(customer_.id_, customer_.name_, customer_.email_);
  }

  function updateKycDoneBy(address id_) internal {
    require(id_ != address[0], " Customer Id is empty");
    customers[id_].kycVerifiedBy = msg.sender;
  }

  function updateDataHash(string memory hash_, uint256 currentTime_) internal {
    customers[msg.sender].dataHash = hash_;
    customers[msg.sender].dataUpdatedOn = currentTime_;
    emit DataHashUpdated(msg.sender, customers[msg.sender].name, hash_);
  }

  function searchCustomers(address id_, address[] memory customers_) 
    internal view returns (bool, Types.Customer memory) {
      bool found_;
      Types.Customer memory customer_;

      for (uint256 i = 0; i < customers_.length; i++) {
        if (customers_[i] == id_) {
          found_ = true;
          customer_ = customers_[id_];
          break;
        }
      }

      return (found_, customer_);
  }

}
