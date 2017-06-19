pragma solidity ^0.4.11;


import "./StandardToken.sol";

contract MTTPToken is StandardToken {

  string public constant name = "MTTPToken";
  string public constant symbol = "MTC";
  uint public constant decimals = 18;
  uint public constant blocksPerPhase = 42000;
  address public target = 0xaea169db31cdd2375bafc08fdb2b56e437edafc6;
 /* address public target = 0x5B6b68eeC6836cC7017Ba3f39CD022Ca4c377c90; */
  uint public firstblock = 0;

  struct Fee {
    address collector;
    uint8 percentage;
  }

  mapping(address => Fee) public proxies;

  event MttpIcoStarted(uint firstblock);
  event InvalidCaller(address caller);
  event NotStartedYet();
  event AlreadyStarted(uint firstblock);

  modifier isOwner {
    if (target == msg.sender) {
        _;
    }
    else InvalidCaller(msg.sender);
  }

  modifier afterStart {
    if (firstblock > 0) {
        _;
    }
    else NotStartedYet();
  }

  modifier beforeStart {
    if (firstblock == 0) {
        _;
    }
    else AlreadyStarted(firstblock);
  }

  function start(uint _firstblock) public isOwner beforeStart returns (uint) {
    if (firstblock > 0 || _firstblock <= block.number) {
      throw;
    }
    firstblock = _firstblock;
    MttpIcoStarted(firstblock);
    return firstblock;
  }

  function addProxy(address proxy, address collector, uint8 percentage) public isOwner {
    if (percentage > 10 || collector == 0x0 || collector == address(this)) {
      throw;
    }
    proxies[proxy] = Fee(collector, percentage); 
  }

  function () payable {
    createTokens(msg.sender);
  }

  function createTokens(address recipient) payable afterStart {
    if (msg.value == 0) {
      throw;
    }

    uint tokens = msg.value.mul(getPrice());
    totalSupply = totalSupply.add(tokens * 2);

    balances[recipient] = balances[recipient].add(tokens);
    balances[target] = balances[target].add(tokens);

    Fee fee = proxies[msg.sender];
    uint feeValue = msg.value.div(100).mul(fee.percentage);
    uint netIncomeValue = msg.value - feeValue;

    if (!target.send(netIncomeValue)) {
      throw;
    }

    if (feeValue > 0 && !fee.collector.send(feeValue)) {
      throw;
    }
  }

  /**
   * @return The price per unit of token. 
   */
  function getPrice() constant returns (uint result) {
    if (block.number >= firstblock + blocksPerPhase * 5) {
      throw;
    }
    if (block.number >= firstblock + blocksPerPhase * 4) {
      return 3800;
    }
    if (block.number >= firstblock + blocksPerPhase * 3) {
      return 4000;
    }
    if (block.number >= firstblock + blocksPerPhase * 2) {
      return 4250;
    }
    if (block.number >= firstblock + blocksPerPhase) {
      return 4550;
    }
    if (block.number >= firstblock) {
      return 4800;
    }
  }
}
