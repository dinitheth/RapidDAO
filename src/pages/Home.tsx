import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Plus, Vote } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { ProposalCard } from '@/components/ProposalCard';
import { useWeb3 } from '@/context/Web3Context';

export const Home = () => {
  const { proposals, fetchProposals, isLoading, account } = useWeb3();

  useEffect(() => {
    fetchProposals();
  }, []);

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Hero Section */}
      <div className="bg-gradient-to-br from-blue-600 to-blue-800 text-white">
        <div className="container mx-auto px-4 py-16">
          <div className="max-w-3xl mx-auto text-center space-y-6">
            <h1 className="text-5xl font-bold">Uncensorable Governance</h1>
            <p className="text-xl text-blue-100">
              Create and vote on proposals directly on the Base blockchain.
            </p>
            <div className="pt-8">
              <Link to="/create">
                <Button size="lg" className="bg-white text-blue-600 hover:bg-blue-50">
                  <Plus className="h-5 w-5 mr-2" />
                  Create Proposal
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </div>

      {/* Proposals Grid */}
      <div className="container mx-auto px-4 py-12">
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-slate-900 mb-2">Active Proposals</h2>
          <p className="text-slate-600">Vote on proposals and shape the future of the DAO</p>
        </div>

        {isLoading ? (
          <div className="text-center py-12">
            <div className="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-blue-600 border-r-transparent"></div>
            <p className="mt-4 text-slate-600">Loading proposals...</p>
          </div>
        ) : proposals.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-lg border-2 border-dashed border-slate-300">
            <Vote className="h-16 w-16 mx-auto text-slate-400 mb-4" />
            <h3 className="text-xl font-semibold text-slate-700 mb-2">No proposals yet</h3>
            <p className="text-slate-500 mb-6">Be the first to create a proposal!</p>
            <Link to="/create">
              <Button className="bg-blue-600 hover:bg-blue-700 text-white">
                <Plus className="h-4 w-4 mr-2" />
                Create First Proposal
              </Button>
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {proposals.map((proposal) => (
              <ProposalCard
                key={proposal.id}
                id={proposal.id}
                title={proposal.title}
                description={proposal.description}
                yesVotes={proposal.yesVotes}
                noVotes={proposal.noVotes}
                isOpen={proposal.isOpen}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
