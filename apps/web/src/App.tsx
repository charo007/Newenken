import { useEffect, useState } from 'react'

export default function App() {
  const [estado, setEstado] = useState('consultando...')

  useEffect(() => {
    fetch('/api/health')
      .then((r) => r.json())
      .then((d) => setEstado(`API: ${d.status}`))
      .catch(() => setEstado('API: sin conexión'))
  }, [])

  return (
    <main style={{ fontFamily: 'sans-serif', padding: 24 }}>
      <h1>Newenken</h1>
      <p>{estado}</p>
    </main>
  )
}