 // SPDX - License-Identifier : MIT 
pragma solidity ^0.8.2;

contract Voting {
    struct Candidate{
        uint256 id;
        string name;
        uint256 numberOfVotes;
    }
    //List of all cands
    Candidate[] public candidates; 
    // owner's address
    address public owner;
    // map all voters' addresses
    mapping(address => bool) public voters;
    // list of voters
    address[] public listOfVoters;

    //start and end sesion
    uint256 public votingStart;
    uint256 public votingEnd;

    // election status 
    bool public electionStarted;
    
    // we ve created all necessary variables

    //modifiers 

    //restrict creating election to the owner only
    modifier onlyOwner(){
        require(msg.sender == owner, "You are not authorised to start an election");
        _;
    }
    //checking if an election is ongoing
    modifier electionOnGoing() {
        require(electionStarted, "No Election yet");
        _;
    }

    // creating a constructor
    constructor() {
        owner = msg.sender;
    }

    //functions

    //to start an election
    function startElection(
        string[] memory _candidates,
        uint256 _votingDuration
        ) public onlyOwner {
            require(electionStarted == false, "Election is currently ongoing");
            delete candidates;
            resetAllVoterStatus();

            for(uint256 i=0; i< _candidates.length; i++) {
                candidates.push(
                    Candidate({id: i, name: _candidates[i], numberOfVotes:0})
                );
            }
            electionStarted = true;
            votingStart = block.timestamp;
            votingEnd = block.timestamp + (_votingDuration * 1 minutes);
    }

    //to add new cand
    function addCandidate(
        string memory _name
        ) public onlyOwner electionOnGoing {
        require(checkElectionPeriod(), "Election period has ended");
        candidates.push(
            Candidate({id: candidates.length, name: _name, numberOfVotes: 0})
        );
    }

    //check voter's status
    function voterStatus(
        address _voter
        ) public view electionOnGoing returns (bool) {
        if(voters[_voter] == true) {
            return true;
        }
        return false;
    }

    //to vote function
    function voteTo(uint256 _id) public electionOnGoing {
        require(checkElectionPeriod(), "election period has ended");
        require(
            !voterStatus(msg.sender),
            "You already voted. You can only vote once"
            );
        candidates[_id].numberOfVotes++;
        voters[msg.sender] = true;
        listOfVoters.push(msg.sender);
    }

    //get number of votes'
    function retriveVotes() public view returns (Candidate[] memory) {
        return candidates;
    }

    //monitor the election time
    function electionTimer() public view electionOnGoing returns (uint256) {
        if(block.timestamp >= votingEnd) {
            return 0;
        }
        return(votingEnd - block.timestamp);
    }

    //check if election period is still ongoing
    function checkElectionPeriod() public returns (bool) {
        if(electionTimer() > 0) {
            return true;
        }
        electionStarted = false;
        return false;
    }

    //reset the voter's status
    function resetAllVoterStatus() public onlyOwner {
        for(uint256 i = 0; i < listOfVoters.length; i++){
            voters[listOfVoters[i]] = false;
        }
        delete listOfVoters;
    }
}