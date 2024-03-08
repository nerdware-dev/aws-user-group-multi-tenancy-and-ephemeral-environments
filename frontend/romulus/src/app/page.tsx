'use client'
import { useEffect, useState } from 'react';
import Image from "next/image";

export default function Home() {
  const [tenant, setTenant] = useState('');

  useEffect(() => {
    fetch(`${process.env.NEXT_PUBLIC_API_URL}/tenant`)
      .then(response => response.text())
      .then(data => setTenant(data));
  }, []);

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-gradient-to-b from-red-300 to-red-700">
      <h1 className="text-6xl font-bold mb-8">Welcome to the Rome</h1>
      <h1 className="text-4xl font-bold mb-8">of {tenant}</h1>
      <Image
        src="/romulus.jpg"
        alt="Romulus"
        width={500}
        height={500}
      />
    </main>
  );
}