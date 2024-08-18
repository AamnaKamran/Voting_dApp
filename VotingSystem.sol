pragma solidity ^0.8.0;

contract Voting {
    // State variables
    uint votingStartTime;
    uint votingDuration;
    bool pollStarted;
    bool pollEnded;
    uint public yesVotes;
    uint public noVotes;

    // Events
    event VoteCasted(string voteType);

    // Modifier to check if the poll is active
    modifier onlyDuringVoting() {
        require(pollStarted && !pollEnded, "Voting is not active.");
        _;
    }

    // Modifier to check if the poll has ended
    modifier onlyAfterVoting() {
        require(pollEnded, "Voting has not ended.");
        _;
    }

    // Function to start the poll
    function startPoll(uint _durationInMinutes) public {
        require(!pollStarted, "Poll already started.");
        require(!pollEnded, "Poll has ended.");

        votingStartTime = block.timestamp;
        votingDuration = _durationInMinutes * 1 minutes;
        pollStarted = true;
        pollEnded = false;
    }

    // Function to cast a vote
    function castVote(bool _voteYes) public onlyDuringVoting {
        endPoll();

        if (_voteYes) {
            yesVotes++;
            emit VoteCasted("Yes");
        } else {
            noVotes++;
            emit VoteCasted("No");
        }
    }

    // Function to end the poll
    function endPoll() private  onlyDuringVoting {
        require(block.timestamp >= votingStartTime + votingDuration, "Voting period not over yet.");

        pollEnded = true;
    }

    // Function to get the results
    function getResults() public view onlyAfterVoting returns (string memory result) {
        if (yesVotes > noVotes) {
            result = "Yes";
        } else if (noVotes > yesVotes) {
            result = "No";
        } else {
            result = "Tie";
        }
    }
}
