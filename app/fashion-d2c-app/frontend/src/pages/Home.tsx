import { useEffect, useState } from 'react';
import { productAPI } from '../api';
import type { Product } from '../types';
import ProductList from '../components/ProductList';

export default function Home() {
  const [featured, setFeatured] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    productAPI.getFeatured(4)
      .then(setFeatured)
      .finally(() => setLoading(false));
  }, []);

  return (
    <>
      {/* Hero */}
      <section className="relative bg-linear-to-r from-gray-100 to-white py-20 md:py-28">
        <div className="container mx-auto px-4 text-center max-w-3xl">
          <span className="text-sm uppercase tracking-widest text-gray-500 font-semibold">Direct-to-Consumer</span>
          <h1 className="text-4xl md:text-6xl font-bold mt-4 leading-tight">
            Timeless style, <br />
            <span className="bg-linear-to-r from-gray-800 to-gray-500 bg-clip-text text-transparent">no middlemen.</span>
          </h1>
          <p className="text-gray-600 text-lg mt-6">Ethically made, sustainably sourced. Shop the latest collection.</p>
          <div className="flex flex-wrap justify-center gap-4 mt-8">
            <a href="/products" className="bg-black text-white px-8 py-3 rounded-full font-medium hover:bg-gray-800 transition shadow-md">Shop Women</a>
            <a href="/products" className="border border-gray-300 text-gray-800 px-8 py-3 rounded-full font-medium hover:bg-gray-100 transition">Shop Men</a>
          </div>
        </div>
      </section>

      {/* Featured Products */}
      {loading ? (
        <div className="container mx-auto p-12 text-center">Loading featured...</div>
      ) : (
        <ProductList products={featured} title="Featured Collection" />
      )}
    </>
  );
}