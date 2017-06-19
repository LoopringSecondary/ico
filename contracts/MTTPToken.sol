pragma solidity ^0.4.11;


import "./StandardToken.sol";

contract MTTPToken is StandardToken {

  string public constant name = "MTTPToken";
  string public constant symbol = "MTC";
  uint public constant decimals = 18;
  uint public constant blocksPerPhase = 42000;
  uint16[5] public phases = [4800, 4550, 4250, 4000, 3800];
  address public target = 0xaea169db31cdd2375bafc08fdb2b56e437edafc6;
 /* address public target = 0x5B6b68eeC6836cC7017Ba3f39CD022Ca4c377c90; */
  uint public firstblock = 0;

  struct Fee {
    address collector;
    uint8 ethPerc;
    uint8 mtcPerc;
  }

  mapping(address => Fee) public proxies;

  event SaleStarted();
  event SaleEnded();
  event InvalidCaller(address caller);
  event InvalidState();
  event Issue(address addr, uint value);

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
    else InvalidState();
  }

  modifier beforeStart {
    if (firstblock == 0) {
        _;
    }
    else InvalidState();
  }

  function start(uint _firstblock) public isOwner beforeStart returns (uint) {
    if (firstblock > 0 || _firstblock <= block.number) {
      throw;
    }
    firstblock = _firstblock;
    SaleStarted();
    return firstblock;
  }

  function addProxy(address proxy, address collector, uint8 ethPerc, uint8 mtcPerc) public isOwner {
    if (ethPerc > 10 || mtcPerc > 10 ||
    collector == 0x0 || collector == address(this)) {
      throw;
    }
    proxies[proxy] = Fee(collector, ethPerc, mtcPerc); 
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

    Fee fee = proxies[msg.sender];
    uint ethFeeValue = msg.value.div(100).mul(fee.ethPerc);
    uint mtcFeeValue = tokens.div(100).mul(fee.mtcPerc);

    balances[recipient] = balances[recipient].add(tokens);
    Issue(recipient, tokens);

    balances[target] = balances[target].add(tokens - mtcFeeValue);
    Issue(target, tokens - mtcFeeValue);

    if (mtcFeeValue > 0) {
      balances[fee.collector] = balances[fee.collector].add(mtcFeeValue);
      Issue(fee.collector, mtcFeeValue);
    }

    if (!target.send(msg.value - ethFeeValue)) {
      throw;
    }

    if (ethFeeValue > 0 && !fee.collector.send(ethFeeValue)) {
      throw;
    }
  }

  /**
   * @return The price per unit of token. 
   */
  function getPrice() constant returns (uint result) {
    uint phaseIdx = (block.number - firstblock) / blocksPerPhase;
    if (phaseIdx > phases.length) {
      SaleEnded();
      throw;
    }
    return phases[phaseIdx];
  }
}
