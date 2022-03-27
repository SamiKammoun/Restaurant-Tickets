// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Restaurant {
  address[] public ticketCompanies;
  address[] public restaurants;
  ticket[] private ticketsList;
  mapping (address => bool) public isRestaurant;
  mapping (address => bool) public isTicketCompany;
  mapping (address => ticket[]) private usedTicketsOf;
  mapping (address => ticket[]) private issuedTicketsOf;
  mapping (uint256 => ticket) private tickets;
  struct ticket{
    bool isValid;
    uint256 number;
    address issuedBy;
    uint256 usedOn;
    uint256 value;
  }
  address public owner;
  constructor() {
    owner = msg.sender;
  }
  modifier OnlyOwner {
    require(msg.sender == owner, "Only the owner can do this operation.");
    _;
  }
  function getTicketsList() public view OnlyOwner returns(ticket[] memory){
    return ticketsList;
  }
  modifier notRestaurant(address _restaurant) {
    require(!isRestaurant[_restaurant],"This is already a restaurant.");
    _;
  }
  modifier notCompany(address _company) {
    require(!isTicketCompany[_company],"This is already a company.");
    _;
  }
  function addRestaurant(address _restaurant) public OnlyOwner notRestaurant(_restaurant) {
    restaurants.push(_restaurant);
    isRestaurant[_restaurant] = true;
  }
  function addCompany(address _company) public OnlyOwner notCompany(_company){
    ticketCompanies.push(_company);
    isTicketCompany[_company] = true;
  }
  function addTickets(uint256[] memory numbers, address companyAddress, uint256[] memory values) public OnlyOwner {
    require(isTicketCompany[companyAddress]);
    require(numbers.length == values.length,"Please check passed parameters");
    for(uint256 i=0;i<numbers.length;i++){
      ticket memory _ticket = ticket(true,numbers[i],companyAddress,0,values[i]);
      tickets[numbers[i]] = _ticket;
      ticketsList.push(_ticket);
      issuedTicketsOf[companyAddress].push(_ticket);
    }
  }
  function useTicket(ticket memory _ticket,address _restaurant) private {//internal or private ?
    _ticket.isValid = false;
    _ticket.usedOn = block.timestamp;
    usedTicketsOf[_restaurant].push(_ticket);
  }
  function useTickets(uint256[] memory _ticketsNumbers, address[] memory _restaurants) public OnlyOwner{
    for(uint256 i=0; i<_ticketsNumbers.length;i++){
      useTicket(tickets[_ticketsNumbers[i]],_restaurants[i]);
    }
  }


}
