// SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0<0.9.0;

contract EventOrganizer
{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
    function createEvent(string memory name, uint date, uint price, uint ticketCount) external
    {
        require(date>block.timestamp,"you can organize for future date.");
        require(ticketCount>0,"you can organize event if you can create more than 0 tickets.");
        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;
    }
    function butTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,"event does not exixt.");
        require(events[id].date>block.timestamp,"Event has already occured.");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ethers are not enough.");
        require(_event.ticketRemain>=quantity,"not enough tickets.");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id] += quantity;
    }
    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date!=0,"event does not exixt.");
        require(events[id].date>block.timestamp,"Event has already occured.");
        require(tickets[msg.sender][id]>=quantity,"you dont have enough tickets.");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
