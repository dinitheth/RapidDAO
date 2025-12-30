// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../src/RapidDAO.sol";

contract RapidDAOTest is Test {
    RapidDAO public dao;
    address public user1;
    address public user2;
    address public user3;

    function setUp() public {
        dao = new RapidDAO();
        user1 = address(0x1);
        user2 = address(0x2);
        user3 = address(0x3);
    }

    function testCreateProposal() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "This is a test proposal");
        
        assertEq(dao.getProposalCount(), 1);
        
        RapidDAO.Proposal memory proposal = dao.getProposal(0);
        assertEq(proposal.id, 0);
        assertEq(proposal.title, "Test Proposal");
        assertEq(proposal.description, "This is a test proposal");
        assertEq(proposal.yesVotes, 0);
        assertEq(proposal.noVotes, 0);
        assertEq(proposal.isOpen, true);
        assertEq(proposal.creator, user1);
    }

    function testVoteYes() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "Description");
        
        vm.prank(user2);
        dao.vote(0, true);
        
        RapidDAO.Proposal memory proposal = dao.getProposal(0);
        assertEq(proposal.yesVotes, 1);
        assertEq(proposal.noVotes, 0);
    }

    function testVoteNo() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "Description");
        
        vm.prank(user2);
        dao.vote(0, false);
        
        RapidDAO.Proposal memory proposal = dao.getProposal(0);
        assertEq(proposal.yesVotes, 0);
        assertEq(proposal.noVotes, 1);
    }

    function testMultipleVotes() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "Description");
        
        vm.prank(user1);
        dao.vote(0, true);
        
        vm.prank(user2);
        dao.vote(0, true);
        
        vm.prank(user3);
        dao.vote(0, false);
        
        RapidDAO.Proposal memory proposal = dao.getProposal(0);
        assertEq(proposal.yesVotes, 2);
        assertEq(proposal.noVotes, 1);
    }

    function testCannotVoteTwice() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "Description");
        
        vm.prank(user2);
        dao.vote(0, true);
        
        vm.prank(user2);
        vm.expectRevert("Already voted on this proposal");
        dao.vote(0, false);
    }

    function testHasVoted() public {
        vm.prank(user1);
        dao.createProposal("Test Proposal", "Description");
        
        assertEq(dao.hasVoted(0, user2), false);
        
        vm.prank(user2);
        dao.vote(0, true);
        
        assertEq(dao.hasVoted(0, user2), true);
    }

    function testMultipleProposals() public {
        vm.prank(user1);
        dao.createProposal("Proposal 1", "Description 1");
        dao.createProposal("Proposal 2", "Description 2");
        dao.createProposal("Proposal 3", "Description 3");
        
        assertEq(dao.getProposalCount(), 3);
        
        RapidDAO.Proposal memory proposal2 = dao.getProposal(1);
        assertEq(proposal2.title, "Proposal 2");
    }
}
