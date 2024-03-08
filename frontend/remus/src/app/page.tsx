import Image from "next/image";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-gradient-to-b from-red-300 to-red-700">
      <h1 className="text-6xl font-bold mb-8">Welcome to the Rome</h1>
      <h1 className="text-4xl font-bold mb-8">of Remus</h1>
      <Image
        src="/remus.jpg"
        alt="Remus"
        width={500}
        height={500}
      />
    </main>
  );
}