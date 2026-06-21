import { Link } from 'react-router-dom';

export default function Header() {
  return (
    <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-gray-200">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <Link to="/" className="text-2xl font-bold tracking-tight bg-gradient-to-r from-gray-900 to-gray-500 bg-clip-text text-transparent">
          THREAD&CO
        </Link>
        <nav className="hidden md:flex gap-8 text-sm font-medium">
          <Link to="/" className="hover:text-gray-600">Home</Link>
          <Link to="/products" className="hover:text-gray-600">Shop</Link>
          <a href="#" className="hover:text-gray-600">New Arrivals</a>
          <a href="#" className="hover:text-gray-600">Sale</a>
        </nav>
        <div className="flex items-center gap-4">
          <button className="relative p-2 hover:bg-gray-100 rounded-full transition">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6h11L17 13" />
            </svg>
            <span className="absolute -top-1 -right-1 bg-black text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">0</span>
          </button>
        </div>
      </div>
    </header>
  );
}