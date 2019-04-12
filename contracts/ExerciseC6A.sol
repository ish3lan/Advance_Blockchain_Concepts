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
     requireContractOwner
     requireIsOperational
     {
        operational = false;
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
    }
}

