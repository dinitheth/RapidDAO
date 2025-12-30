// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract RapidDAO {
    /// @notice Proposal structure
    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool isOpen;
        address creator;
        uint256 timestamp;
    }

    /// @notice Events
    event ProposalCreated(uint256 indexed proposalId, string title, address creator);
    event VoteCast(uint256 indexed proposalId, bool voteYes, address voter, uint256 totalYes, uint256 totalNo);

    /// @notice State variables
    uint256 private proposalCount;
    mapping(uint256 => Proposal) private proposals;
    mapping(uint256 => mapping(address => bool)) private hasVotedMapping;

    /// @notice Creates a new proposal
    /// @param title The title of the proposal
    /// @param description The description of the proposal
    function createProposal(string memory title, string memory description) external {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        uint256 proposalId = proposalCount;
        
        proposals[proposalId] = Proposal({
            id: proposalId,
            title: title,
            description: description,
            yesVotes: 0,
            noVotes: 0,
            isOpen: true,
            creator: msg.sender,
            timestamp: block.timestamp
        });

        proposalCount++;

        emit ProposalCreated(proposalId, title, msg.sender);
    }

    /// @notice Vote on a proposal
    /// @param proposalId The ID of the proposal to vote on
    /// @param voteYes True for YES vote, false for NO vote
    function vote(uint256 proposalId, bool voteYes) external {
        require(proposalId < proposalCount, "Proposal does not exist");
        require(proposals[proposalId].isOpen, "Proposal is not open");
        require(!hasVotedMapping[proposalId][msg.sender], "Already voted on this proposal");

        hasVotedMapping[proposalId][msg.sender] = true;

        if (voteYes) {
            proposals[proposalId].yesVotes++;
        } else {
            proposals[proposalId].noVotes++;
        }

        emit VoteCast(proposalId, voteYes, msg.sender, proposals[proposalId].yesVotes, proposals[proposalId].noVotes);
    }

    /// @notice Get proposal details
    /// @param proposalId The ID of the proposal
    /// @return The proposal struct
    function getProposal(uint256 proposalId) external view returns (Proposal memory) {
        require(proposalId < proposalCount, "Proposal does not exist");
        return proposals[proposalId];
    }

    /// @notice Get total number of proposals
    /// @return The total proposal count
    function getProposalCount() external view returns (uint256) {
        return proposalCount;
    }

    /// @notice Check if an address has voted on a proposal
    /// @param proposalId The ID of the proposal
    /// @param voter The address to check
    /// @return True if the address has voted, false otherwise
    function hasVoted(uint256 proposalId, address voter) external view returns (bool) {
        require(proposalId < proposalCount, "Proposal does not exist");
        return hasVotedMapping[proposalId][voter];
    }
}
