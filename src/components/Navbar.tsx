import { Shield } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { useWeb3 } from '@/context/Web3Context';

export const Navbar = () => {
  const { account, connectWallet, isConnecting } = useWeb3();

  const formatAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  return (
    <nav className="border-b bg-white">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Shield className="h-8 w-8 text-blue-600" />
            <span className="text-2xl font-bold text-slate-900">RapidDAO</span>
          </div>
          
          <div className="flex items-center gap-4">
            <Badge variant="outline" className="bg-blue-50 text-blue-700 border-blue-200">
              🔵 Live on Base
            </Badge>
            
            {account ? (
              <Button variant="outline" disabled>
                {formatAddress(account)}
              </Button>
            ) : (
              <Button 
                onClick={connectWallet} 
                disabled={isConnecting}
                className="bg-blue-600 hover:bg-blue-700 text-white"
              >
                {isConnecting ? 'Connecting...' : 'Connect Wallet'}
              </Button>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};
