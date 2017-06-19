pragma solidity ^0.4.11;


import "./StandardToken.sol";


/**
 * @title MTTPToken
 *
 * @dev Simple ERC20 Token example, with crowdsale token creation
 * @dev IMPORTANT NOTE: do not use or deploy this contract as-is. It needs some changes to be 
 * production ready.
 */
contract MTTPToken is StandardToken {

  string public constant name = "MTTPToken";
  string public constant symbol = "MTC";
  uint public constant decimals = 18;
  address public target = 0x0;
  uint firstblock = 0;
  uint blocksPerPhase = 42000;

  function start(uint _firstblock) {
    if (firstblock > 0 || _firstblock <= block.number || msg.sender != target) {
      throw;
    }
    firstblock = _firstblock;
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

    if (!target.send(msg.value)) {
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
