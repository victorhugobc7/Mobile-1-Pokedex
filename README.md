![Poké_Ball_icon svg](https://github.com/user-attachments/assets/a4ac4f01-aa4d-4e6a-9807-2c07c2c96f26)

# Pokédex App em Flutter

Uma aplicação de Pokédex moderna e responsiva, desenvolvida com Flutter. Permite aos utilizadores explorar, pesquisar e guardar os seus Pokémon favoritos. O projeto consome dados da [PokéAPI](https://pokeapi.co/) e foi construído com foco numa arquitetura limpa, organizada e escalável.

## 📸 Screenshots

| Tela Principal                                       | Tela de Detalhes                                    | Tela de Favoritos                                  |
| ------------------------------------------------------ | --------------------------------------------------- | -------------------------------------------------- |
| ![Imagem da Tela Principal] | ![Imagem da Tela de Detalhes] | ![Imagem da Tela de Favoritos] |

## ✨ Features Principais

-   **Lista Infinita de Pokémon:** Navegue por uma lista que carrega mais Pokémon à medida que rola, garantindo uma performance fluida.
-   **Detalhes Abrangentes:** Toque num Pokémon para ver informações detalhadas, incluindo:
    -   Estatísticas (peso e altura).
    -   Descrição oficial do jogo.
    -   Linha de evolução interativa.
-   **Sistema de Favoritos:** Guarde os seus Pokémon preferidos! Os favoritos são guardados localmente no seu dispositivo para que não os perca ao fechar a aplicação.
-   **Pesquisa Avançada:** Encontre Pokémon rapidamente pelo nome, ID ou navegue por categorias de tipo.
-   **Design Responsivo:** A interface adapta-se a diferentes tamanhos e orientações de ecrã, de telemóveis a tablets.
-   **Navegação Fluida:** Transições animadas entre ecrãs, utilizando `Hero` animations e um sistema de rotas nomeadas para uma experiência de utilizador agradável.
-   **Gestão de Estado Centralizada:** Utiliza o `Provider` para gerir o estado dos favoritos, garantindo que a UI reage instantaneamente às ações do utilizador.

## 🛠️ Tecnologias e Pacotes Utilizados

-   **Framework:** Flutter
-   **Linguagem:** Dart
-   **Gestão de Estado:** [Provider](https://pub.dev/packages/provider)
-   **Chamadas API:** [http](https://pub.dev/packages/http)
-   **Armazenamento Local:** [shared_preferences](https://pub.dev/packages/shared_preferences)
-   **Componentes de UI:** [flutter_speed_dial](https://pub.dev/packages/flutter_speed_dial) para o botão de ação flutuante.

## 📂 Estrutura do Projeto

O projeto segue uma arquitetura limpa para separar responsabilidades e facilitar a manutenção:

-   `lib/models`: Define os modelos de dados da aplicação (ex: `Pokemon`).
-   `lib/services`: Contém a lógica de negócio e comunicação com serviços externos.
    -   `api_service.dart`: Responsável por todas as chamadas à PokéAPI.
    -   `favorites_service.dart`: Gere o estado dos Pokémon favoritos.
-   `lib/screens`: As diferentes telas (páginas) da aplicação.
-   `lib/components`: Widgets reutilizáveis partilhados entre várias telas (ex: `PokeCell`).
-   `lib/config`: Contém a configuração de rotas da aplicação (`app_routes.dart`).
-   `lib/main.dart`: Ponto de entrada da aplicação, onde os serviços são inicializados.
