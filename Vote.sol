pragma solidity ^0.4.16;

contract ERC20 {

    string public name;
    string public symbol;
    uint8 public decimals = 8;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => string) public  keys;

    function transfer(address _to, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function register(string key) public;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Register (address user, string key);
}

contract BallotManager {

    event CreateBallot(uint256 ballotId, string ballotName);

    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    struct Ballot {
        string     name;
        uint       proposalSize;
        mapping(uint => Proposal) proposals;
        mapping(address => Voter) voters;
    }

    Ballot[] ballots;
    ERC20 public xcareTokenContract;
    address chairperson;

    function BallotManager() public {
        chairperson = msg.sender;
    }

    function setERC20Address(address _erc20Address) external {
        require(msg.sender == chairperson);
        xcareTokenContract = ERC20(_erc20Address);
    }

    function NewBallot(string ballotname, bytes32[] proposalNames) public {
        require(msg.sender == chairperson);
        
        ballots.push(Ballot({name: ballotname, proposalSize :proposalNames.length}));
        uint256 newBallotId = ballots.length - 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            ballots[newBallotId].proposals[i] = (Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }

        CreateBallot(newBallotId, ballotname);
    }

    function vote(uint256 ballotId, uint proposal) public {
        require(ballotId < ballots.length);
        require(proposal < ballots[ballotId].proposalSize);

        Voter storage voter = ballots[ballotId].voters[msg.sender];
        require(!voter.voted);
        voter.voted = true;
        voter.vote = proposal;
        voter.weight = xcareTokenContract.balanceOf(msg.sender);

        ballots[ballotId].proposals[proposal].voteCount += voter.weight;
    }

    function winningProposal(uint256 ballotId) public view returns (uint winningProposal_) {
        require(ballotId < ballots.length);

        uint winningVoteCount = 0;
        Ballot storage ballot = ballots[ballotId];
        uint len = ballot.proposalSize;
        for (uint p = 0; p < len; p++) {
            if (ballot.proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = ballot.proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName(uint256 ballotId) public view returns (bytes32 winnerName_) {
        require(ballotId < ballots.length);

        winnerName_ = ballots[ballotId].proposals[winningProposal(ballotId)].name;
    }
}
