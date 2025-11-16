# Kingdoms - Applications GOTK8S

Ce répertoire contient le code source de toutes les applications (royaumes) de GOTK8S.

## Structure

```
kingdoms/
├── the-north/           # 🐺 The North - Ravens Messaging
│   ├── frontend/        # Interface web
│   ├── backend/         # API Node.js
│   └── README.md
├── dorne/               # ☀️ Dorne - Commerce (À VENIR)
├── the-reach/           # 🌹 The Reach - Resources (À VENIR)
├── the-vale/            # 🦅 The Vale - Auth (À VENIR)
├── the-riverlands/      # 🌊 The Riverlands - Cache (À VENIR)
├── the-westerlands/     # 🦁 The Westerlands - Finance (À VENIR)
├── the-citadel/         # 📚 The Citadel - Database (À VENIR)
└── kings-landing/       # 👑 King's Landing - API Gateway (À VENIR)
```

## The North - Disponible ✅

Système de messagerie utilisant des "Ravens" (corbeaux) pour communiquer entre royaumes.

**Stack technique:**
- Frontend: HTML/CSS/JavaScript vanilla + Socket.IO client
- Backend: Node.js + Express + Socket.IO
- Database: Redis

**Fonctionnalités:**
- Envoi de messages entre royaumes
- Communication en temps réel (WebSocket)
- Historique des messages
- Priorités (normal, high, urgent)
- Statistiques

**Déploiement:**
```bash
# Build
./build-images.sh

# Deploy
./deploy-gotk8s.sh
```

## Build toutes les images

```bash
./build-images.sh
```

Cela va construire toutes les images Docker disponibles.

## Développement local

### The North Backend

```bash
cd the-north/backend
npm install
npm run dev

# L'API tourne sur http://localhost:3000
```

### The North Frontend

```bash
cd the-north/frontend
# Servir avec n'importe quel serveur web
python3 -m http.server 8000

# Ou
npx serve .
```

## Contribuer

Pour ajouter un nouveau royaume :

1. Créer le répertoire avec `frontend/` et `backend/`
2. Ajouter les Dockerfiles
3. Créer les manifestes K8s dans `manifests/gotk8s/`
4. Mettre à jour ce README
5. Créer un scénario d'apprentissage

## Roadmap

- [x] The North (Ravens Messaging)
- [ ] Dorne (Commerce API)
- [ ] The Reach (Resources GraphQL)
- [ ] The Vale (Authentication OAuth2)
- [ ] The Riverlands (Distributed Cache)
- [ ] The Westerlands (Finance + Queue)
- [ ] The Citadel (Database HA)
- [ ] King's Landing (API Gateway)

---

**"When you play the game of thrones, you win or you die. When you play with Kubernetes, you learn!"**
