pragma solidity ^0.4.11;


import "./StandardToken.sol";

contract MTTPToken is StandardToken {

  string public constant name = "MTTPToken";
  string public constant symbol = "MTC";
  uint public constant decimals = 18;
  address public target = 0x5B6b68eeC6836cC7017Ba3f39CD022Ca4c377c90;
  uint firstblock = 0;
  uint blocksPerPhase = 42000;

  struct Fee {
    address collector;
    uint8 percentage;
  }

  mapping(address => Fee) public proxies;

  event MttpIcoStarted(uint firstblock);

  function start(uint _firstblock) public {
    if (firstblock > 0 ||
    _firstblock <= block.number ||
    msg.sender != target) {
      throw;
    }
    firstblock = _firstblock;
    MttpIcoStarted(firstblock);
  }

  function addProxy(address proxy, address collector, uint8 percentage) public {
    if (firstblock > 0 ||
    msg.sender != target ||
    percentage > 10 ||
    collector == 0x0 ||
    collector == address(this)) {
      throw;
    }
    proxies[proxy] = Fee(collector, percentage); 
  }

  function () payable {
    createTokens(msg.sender);
  }

  function createTokens(address recipient) payable {
    if (firstblock == 0 || msg.value == 0) {
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
