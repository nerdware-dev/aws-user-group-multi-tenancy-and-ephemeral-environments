import Head from "next/head";
import { useEffect, useState } from "react";

const API_URL = `${process.env.NEXT_PUBLIC_API_URL}/data`;

export default function Home() {
  const [data, setData] = useState<string | null>(null);
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    fetch(API_URL)
      .then((res) => res.text())
      .then((data) => {
        setData(data);
        setLoading(false);
      });
  }, []);

  if (isLoading) return <p>Loading...</p>;
  if (!data) return <p>No data</p>;

  return (
    <>
      <Head>
        <title>Demo</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>{data}</main>
    </>
  );
}
