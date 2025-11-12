# 🏦 Simulador de Sistema Bancário (Portugol)

Este é um algoritmo de console altamente estruturado, escrito em Portugol, que simula as operações fundamentais de um sistema bancário. É o projeto mais complexo desta série, demonstrando **registros aninhados** (um `tipo` dentro de outro `tipo`), validação de dados e um menu de operações completo.



## ✨ Funcionalidades Principais

* **1. Abrir Conta:**
    * Permite o cadastro de novos clientes (Titular, Senha).
    * Gera automaticamente um número de conta sequencial (iniciando em 1001).
    * **Validação:** Impede o cadastro se o limite de contas (100) for atingido.

* **2. Depósito:**
    * Permite depositar um valor em qualquer conta existente.
    * **Validação:** A conta de destino deve existir.
    * **Validação:** O valor do depósito deve ser positivo.

* **3. Saque:**
    * Requer autenticação (Número da Conta + Senha) para funcionar.
    * **Validação:** O valor do saque deve ser positivo.
    * **Validação:** O usuário não pode sacar mais do que o saldo disponível.

* **4. Transferência:**
    * Permite a transferência de valores entre duas contas.
    * **Validação Quádrupla:** O sistema verifica:
        1.  Se a conta de **origem** e a **senha** estão corretas.
        2.  Se a conta de **destino** existe.
        3.  Se a origem e o destino **não são a mesma conta**.
        4.  Se a conta de origem possui **saldo suficiente**.
    * Registra a transação nos extratos de *ambas* as contas.

* **5. Consulta de Saldo e Extrato:**
    * Requer autenticação (Número da Conta + Senha).
    * Exibe o saldo atual e um **extrato detalhado** de todas as transações (depósitos, saques, transferências enviadas e recebidas).

## 🏛️ Estrutura e Lógica Avançada (Registros Aninhados)

A maior melhoria deste código é a sua estrutura de dados, que resolve o problema de não poder juntar texto e números (concatenação) no VisualG.

O sistema usa dois Registros (`tipo`):

### 1. `tipo Transacao`
Um registro "filho" que armazena os detalhes de UMA operação:
* `tipoOp` (caractere): "Deposito", "Saque", "Transf. Enviada", etc.
* `valor` (real): O valor da operação.
* `contaRelacionada` (inteiro): O número da outra conta envolvida (em transferências).

### 2. `tipo ContaBancaria`
O registro "pai" que define a conta:
* `numeroConta`, `titular`, `senha`, `saldo`...
* `transacoes: vetor[1..100] de Transacao`: Aqui está a melhoria. Em vez de um vetor de texto, a conta armazena um **vetor do `tipo Transacao`**.

Isso torna o armazenamento de dados muito mais limpo e permite que o extrato seja formatado na hora da exibição, sem nunca precisar quebrar as regras de tipo do Portugol.

### Funções Auxiliares
* `funcao buscarContaPorNumero()`: Uma função de busca eficiente que retorna o *índice* de uma conta no vetor.
* `funcao autenticarUsuario()`: Uma função de segurança que usa a `buscarContaPorNumero` e depois compara a senha.

## 🚀 Como Executar

Para executar este algoritmo, você precisará de um interpretador de Portugol.

1.  **VisualG (Recomendado):**
    * Baixe e instale o [VisualG](http://visualg.com.br/cli/).
    * Copie o código-fonte (`.alg`) do arquivo.
    * Abra o VisualG e cole o código.
    * Pressione **F9** (ou clique em "Rodar") para executar o programa.
