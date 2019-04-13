pragma solidity ^0.4.25;

contract ExerciseC6A {

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/


    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    bool private operational;                       // variable to specify if the contract is operational or paused
    address private contractOwner;                  // Account used to deploy contract
    mapping(address => UserProfile) userProfiles;   // Mapping for storing user profiles


    uint constant M = 2;                            // 2 of 3 admins is needed to perform contract pausing
    address[] pausingCalls = new address[](0);

    event UserRegistered(address user, bool isAdmin);
    event CallPauseContract(address user, bool isAdmin);


    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
    (
        ) 
    public 
    {
        contractOwner = msg.sender;
        operational = true;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireIsOperational(){
        require(operational == true, "This contract is not operational.");
        _;

    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
     * @dev        Pause Contract Operation
     */
     function pauseContract()
     external
     requireIsOperational
     {
        emit CallPauseContract(msg.sender, userProfiles[msg.sender].isAdmin);
        require(userProfiles[msg.sender].isAdmin || msg.sender == contractOwner, "Call to Pause contract from non-admin account");

        bool isDuplicateCall = false;

        // loop to check if call is a duplicate

        for ( uint i = 0 ; i < pausingCalls.length ; i++ ){
            if ( pausingCalls[i] == msg.sender ){
                isDuplicateCall = true;
                break;
            }
        }

        require(!isDuplicateCall, "Duplicate call to pause contract from the same admin.");

        pausingCalls.push(msg.sender);

        if (pausingCalls.length >= M){
            operational = false;
            pausingCalls = new address[](0);
        }
    }


   /**
    * @dev Check if a user is registered
    *
    * @return A bool that indicates if the user is registered
    */   
    function isUserRegistered
    (
        address account
        )
    external
    view
    returns(bool)
    {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser
    (
        address account,
        bool isAdmin
        )
    external
    requireIsOperational
    requireContractOwner
    {
        require(!userProfiles[account].isRegistered, "User is already registered.");

        userProfiles[account] = UserProfile({
            isRegistered: true,
            isAdmin: isAdmin
            });
        emit UserRegistered(account ,isAdmin);
    }


    function isOperational()
    external
    view
    returns(bool)
    {
        return operational;
    }
}
