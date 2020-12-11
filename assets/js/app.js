import "../css/app.css"
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//


import React, { useState, useEffect } from "react"
import ReactDOM from "react-dom"

const csrfToken = document.getElementById("csrf-meta-tag").content;

function NotFound() {
  return <div className="dark:text-white text-center">Looks like we don't know where that link goes 🙁.</div>;
}

function useFetch() {
  const [resp, setResp] = useState(null);

  const submit = async (url) => {
    fetch("/", {
      method: "POST",
      headers: {
        "x-csrf-token": csrfToken,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        link: {
          url: url
        }
      })
    }).then((resp) => resp.json())
      .then(json => setResp(json))
      .catch(error => console.log(error));
  }

  return [resp, submit];
}

function Home() {
  const [url, setUrl] = useState("");
  const [shortenedLink, setShortenedLink] = useState("");
  const [error, setError] = useState(null);
  const [resp, submit] = useFetch();

  useEffect(() => {
    if (resp) {
      setError(null);
      setShortenedLink(null);

      switch (resp.status) {
        case "error":
          setError(resp.message);
          break;

        case "success":
          setUrl("");
          setShortenedLink(resp.message)
          break;
      }
    }
  }, [resp]);

  return (
    <>
      <form action="#" className="px-8 space-y-4" onSubmit={(e) => e.preventDefault() || submit(url)}>
        <label htmlFor="URL" className="hidden">URL</label>
        <input value={url}
          name="URL"
          type="url"
          onChange={(e) => setUrl(e.target.value)}
          className="border-2 border-black p-2 font-normal w-full rounded"
          placeholder="A freakishly long URL..." />
        <button
          type="submit"
          className="w-full rounded uppercase px-4 py-2 tracking-wider text-white bg-black dark:bg-gray-800">
          Shrink!
        </button>
        {error &&
          <div className="space-y-4 border-2 border-red-600 rounded px-4 py-2 text-red-700 bg-red-100">
            <div>Error!</div>

            <ul className="list-disc pl-8">
              <li>{error}</li>
            </ul>
          </div>}
        {shortenedLink &&
          <div className="border-2 dark:border-transparent border-blue-300 rounded px-4 py-2 text-blue-900 bg-blue-200">
            <span>Here is your microscopic link: </span>
            <a className="underline italic hover:font-bold" href={shortenedLink} target="_blank">{shortenedLink}</a>
          </div>}
      </form>
    </>

  );
}

function App() {
  return (
    <div className="space-y-16">
      <h1 className="italic text-center font-bold text-7xl dark:text-white">
        <a href="/">
          🦠 µRL
        </a>
      </h1>
      {window.location.pathname == "/"
        ? <Home />
        : <NotFound />}
    </div>
  );
}

ReactDOM.render(<App />, document.getElementById("root"));
