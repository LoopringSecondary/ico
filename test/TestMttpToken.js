var MTTPToken = artifacts.require("MTTPToken");

contract('MTTPToken', function(accounts) {
   var target = "0x5B6b68eeC6836cC7017Ba3f39CD022Ca4c377c90";

  it("should not allow create of token before it starts", function() {
    var mttp;
    return MTTPToken.deployed().then(function(instance) {
      mttp = instance;
      // console.log(web3.eth.blockNumber);
      return mttp.startSale(accounts[1], 10, {from: accounts[2]});
      // web3.eth.sendTransaction({from: accounts[1], to: mttp.address, value: web3.toWei(10) })

      // return instance.balanceOf.call(accounts[0]);
    }).then(function(firstblock) {
      console.log(firstblock);
      // assert.equal(balance.valueOf(), 0, "10000 wasn't in the first account");
      assert(firstblock, 1000, "afa")
    });
  });

  // it("should send coin correctly", function() {
  //   var meta;

  //   //    Get initial balances of first and second account.
  //   var account_one = accounts[0];

  //   var account_one_starting_balance;
  //   var account_one_ending_balance;

  //   var amount = 10;

  //   return MTTPToken.deployed().then(function(instance) {
  //     meta = instance;
  //     return meta.getBalance.call(account_one);
  //   }).then(function(balance) {
  //     return meta.getBalance.call(account_one);
  //   }).then(function(balance) {
  //     account_one_ending_balance = balance.toNumber();
  //     return meta.getBalance.call(account_two);
  //   }).then(function(balance) {
  //     account_two_ending_balance = balance.toNumber();

  //     assert.equal(account_one_starting_balance, account_one_ending_balancet, "Amount wasn't correctly taken from the sender");
  //   });
  // });
});


// var MTTPToken = artifacts.require("./MTTPToken.sol");

// contract('MTTPToken', function(accounts) {
//   it("should put 10000 MTTPToken in the first account", function() {
//     return MTTPToken.deployed().then(function(instance) {
//       return instance.getBalance.call(accounts[0]);
//     }).then(function(balance) {
//       assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
//     });
//   });
//   it("should call a function that depends on a linked library", function() {
//     var meta;
//     var metaCoinBalance;
//     var metaCoinEthBalance;

//     return MTTPToken.deployed().then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(accounts[0]);
//     }).then(function(outCoinBalance) {
//       metaCoinBalance = outCoinBalance.toNumber();
//       return meta.getBalanceInEth.call(accounts[0]);
//     }).then(function(outCoinBalanceEth) {
//       metaCoinEthBalance = outCoinBalanceEth.toNumber();
//     }).then(function() {
//       assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpeced function, linkage may be broken");
//     });
//   });

//   it("should send coin correctly", function() {
//     var meta;

//     //    Get initial balances of first and second account.
//     var account_one = accounts[0];
//     var account_two = accounts[1];

//     var account_one_starting_balance;
//     var account_two_starting_balance;
//     var account_one_ending_balance;
//     var account_two_ending_balance;

//     var amount = 10;

//     return MTTPToken.deployed().then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(account_one);
//     }).then(function(balance) {
//       account_one_starting_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     }).then(function(balance) {
//       account_two_starting_balance = balance.toNumber();
//       return meta.sendCoin(account_two, amount, {from: account_one});
//     }).then(function() {
//       return meta.getBalance.call(account_one);
//     }).then(function(balance) {
//       account_one_ending_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     }).then(function(balance) {
//       account_two_ending_balance = balance.toNumber();

//       assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
//       assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
//     });
//   });
// });
