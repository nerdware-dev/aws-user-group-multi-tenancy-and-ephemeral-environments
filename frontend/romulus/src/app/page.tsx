'use client'
import { useEffect, useState } from 'react';

export default function Home() {
  const [tenant, setTenant] = useState('');

  useEffect(() => {
    fetch(`${process.env.NEXT_PUBLIC_API_URL}/tenant`)
      .then(response => response.text())
      .then(data => setTenant(data));
  }, []);

  return (
    <div className="relative flex flex-col min-h-screen items-center justify-start pt-24 p-24 bg-gradient-to-b from-red-300 to-red-700">
      <main className="flex flex-col items-center justify-center z-10">
        <h1 className="text-6xl font-bold mb-8">Welcome to the Rome</h1>
        <h1 className="text-4xl font-bold mb-8">of {tenant}</h1>
        <img
          src="/romulus.jpg"
          alt="Romulus"
          width={320}
        />
      </main>
      <div className="absolute bottom-0 left-0 w-full h-64 bg-cover bg-center" style={{ backgroundImage: `url(/skyline.png)`, filter: 'brightness(0)' }} />
    </div>
  );
}