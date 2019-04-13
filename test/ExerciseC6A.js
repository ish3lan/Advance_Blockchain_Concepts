
var Test = require('../config/testConfig.js');

contract('ExerciseC6A', async (accounts) => {

  var config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('contract owner can register new user', async () => {

    // ARRANGE
    let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
    let newUser = config.testAddresses[0]; 

    // ACT
    await config.exerciseC6A.registerUser(newUser, false, {from: caller});
    let result = await config.exerciseC6A.isUserRegistered.call(newUser); 

    // ASSERT
    assert.equal(result, true, "Contract owner cannot register new user");

  });

  // it('contract owner can pause the contract', async () => {

  //   // ARRANGE
  //   let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
  //   // ACT
  //   await config.exerciseC6A.pauseContract({from: caller});

  //   let contractStatus = await config.exerciseC6A.isOperational(); 

  //   // ASSERT
  //   assert.equal(contractStatus, false, "Contract owner cannot register new user");

  // });



  it('function call is made when multi-party threshold is reached', async () => {

    // ARRANGE
    let admin1 = accounts[1];
    let admin2 = accounts[2];
    let admin3 = accounts[3];
    

    config.exerciseC6A.CallPauseContract(function(err,res){
      console.log(err);
      console.log(res);
    }); 

    await config.exerciseC6A.registerUser(admin1, true, {from: config.owner});
    await config.exerciseC6A.registerUser(admin2, true, {from: config.owner});
    await config.exerciseC6A.registerUser(admin3, true, {from: config.owner});
    
    let startStatus = await config.exerciseC6A.isOperational(); 

    assert.equal(startStatus, true, "Contract starting status is not operational.");
    // ACT
    await config.exerciseC6A.pauseContract({from: admin1});
    await config.exerciseC6A.pauseContract({from: admin2});
    
    let newStatus = await config.exerciseC6A.isOperational(); 

    // ASSERT
    assert.equal(newStatus, false, "Multi-party pausing calls failed");

  });


});
