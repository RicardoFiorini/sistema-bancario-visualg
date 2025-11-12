algoritmo "Simulador de Sistema Bancário Avançado"

// --- Constantes de Limite ---
const
   LIMITE_CONTAS = 100
   LIMITE_TRANSACOES = 100

// --- Definição dos Tipos (Registros) ---
// (Deve ser feito ANTES do bloco 'var')

// 1. Um registro para cada Transação
tipo Transacao
   tipoOp: caractere[30] // "Deposito", "Saque", "Transf. Enviada", etc.
   valor: real
   contaRelacionada: inteiro // Para transferências (a outra conta)
fimTipo

// 2. O registro principal da Conta, agora usando o "tipo Transacao"
tipo ContaBancaria
   numeroConta: inteiro
   titular: caractere
   senha: caractere
   saldo: real
   transacoes: vetor[1..LIMITE_TRANSACOES] de Transacao // Vetor de Registros
   totalTransacoes: inteiro
fimTipo

// --- Variáveis Globais ---
var
   contas: vetor[1..LIMITE_CONTAS] de ContaBancaria
   totalContas: inteiro
   opcao: inteiro

// --- Procedimento: Pausa a execução ---
procedimento Pausar()
var
   tecla: caractere
inicio
   escreva("\n(Pressione [ENTER] para voltar ao menu...)")
   leia(tecla)
fimprocedimento

// --- Função: Busca uma conta pelo número ---
// (Retorna o ÍNDICE ou 0 se não encontrar)
funcao buscarContaPorNumero(numero: inteiro) : inteiro
var
   i: inteiro
inicio
   para i de 1 até totalContas faca
      se (contas[i].numeroConta = numero) entao
         retorne i
      fimse
   fimpara
   retorne 0
fimfuncao

// --- Função: Autentica o usuário ---
// (Retorna o ÍNDICE ou 0 se falhar)
funcao autenticarUsuario(numero: inteiro; senhaEntrada: caractere) : inteiro
var
   indice: inteiro
inicio
   indice <- buscarContaPorNumero(numero)
   // Validação 1: Conta existe?
   se (indice = 0) entao
      retorne 0
   fimse
   // Validação 2: Senha confere?
   se (contas[indice].senha = senhaEntrada) entao
      retorne indice
   senao
      retorne 0 // Senha incorreta
   fimse
fimfuncao

// --- Procedimento: Registra uma transação (NOVO MODELO) ---
procedimento registrarTransacao(indiceConta: inteiro; tipo: caractere; valorOp: real; contaExtra: inteiro)
var
   idxTransacao: inteiro
inicio
   // Verifica se há espaço para novas transações
   se (contas[indiceConta].totalTransacoes < LIMITE_TRANSACOES) entao
      
      contas[indiceConta].totalTransacoes <- contas[indiceConta].totalTransacoes + 1
      idxTransacao <- contas[indiceConta].totalTransacoes

      // Preenche o registro da Transação
      contas[indiceConta].transacoes[idxTransacao].tipoOp <- tipo
      contas[indiceConta].transacoes[idxTransacao].valor <- valorOp
      contas[indiceConta].transacoes[idxTransacao].contaRelacionada <- contaExtra
      
   // Se não houver espaço, a transação é perdida (em um sistema real, isso seria um erro)
   fimse
fimprocedimento

// --- Procedimento: Abrir Conta ---
procedimento abrirConta()
var
   novoTitular, novaSenha: caractere
inicio
   limpatela
   escreva("--- Abertura de Conta ---\n")
   

   se (totalContas >= LIMITE_CONTAS) entao
      escreva("[ERRO] Limite máximo de contas (", LIMITE_CONTAS, ") atingido!\n")
   senao
      escreva("Nome do titular: ")
      leia(novoTitular)
      escreva("Crie uma senha para a conta: ")
      leia(novaSenha)

      // Adiciona a conta
      totalContas <- totalContas + 1
      contas[totalContas].titular <- novoTitular
      contas[totalContas].senha <- novaSenha
      contas[totalContas].numeroConta <- 1000 + totalContas
      contas[totalContas].saldo <- 0
      contas[totalContas].totalTransacoes <- 0

      escreva("\nConta aberta com sucesso!\n")
      escreva("Titular: ", contas[totalContas].titular, "\n")
      escreva("Número da Conta: ", contas[totalContas].numeroConta, "\n")
   fimse
fimprocedimento

// --- Procedimento: Depositar ---
procedimento depositar()
var
   numConta, indiceConta: inteiro
   valor: real
inicio
   limpatela
   escreva("--- Depósito ---\n")
   
   escreva("Número da conta para depósito: ")
   leia(numConta)
   
   indiceConta <- buscarContaPorNumero(numConta)
   
   se (indiceConta = 0) entao
      escreva("\n[ERRO] Conta não encontrada.\n")
   senao
      escreva("Digite o valor do depósito: R$ ")
      leia(valor)
      
      // Validação do valor
      se (valor <= 0) entao
         escreva("\n[ERRO] O valor do depósito deve ser positivo.\n")
      senao
         contas[indiceConta].saldo <- contas[indiceConta].saldo + valor
         // Registra a transação (sem conta extra, então 0)
         registrarTransacao(indiceConta, "Depósito", valor, 0)
         escreva("\nDepósito de R$ ", valor:0:2, " realizado com sucesso!\n")
         escreva("Novo saldo: R$ ", contas[indiceConta].saldo:0:2, "\n")
      fimse
   fimse
fimprocedimento

// --- Procedimento: Sacar ---
procedimento sacar()
var
   numConta, indiceConta: inteiro
   senha: caractere
   valor: real
inicio
   limpatela
   escreva("--- Saque ---\n")
   

   escreva("Número da conta: ")
   leia(numConta)
   escreva("Senha: ")
   leia(senha)

   indiceConta <- autenticarUsuario(numConta, senha)
   
   se (indiceConta = 0) entao
      escreva("\n[ERRO] Conta ou senha incorretos.\n")
   senao
      escreva("Digite o valor do saque: R$ ")
      leia(valor)
      
      // Validação do valor
      se (valor <= 0) entao
         escreva("\n[ERRO] O valor do saque deve ser positivo.\n")
      // Validação de saldo
      senao se (contas[indiceConta].saldo < valor) entao
         escreva("\n[ERRO] Saldo insuficiente.\n")
         escreva("Saldo disponível: R$ ", contas[indiceConta].saldo:0:2, "\n")
      senao
         contas[indiceConta].saldo <- contas[indiceConta].saldo - valor
         registrarTransacao(indiceConta, "Saque", valor, 0)
         escreva("\nSaque de R$ ", valor:0:2, " realizado com sucesso!\n")
         escreva("Novo saldo: R$ ", contas[indiceConta].saldo:0:2, "\n")
      fimse
   fimse
fimprocedimento

// --- Procedimento: Transferir ---
procedimento transferir()
var
   numContaOrigem, numContaDestino, iOrigem, iDestino: inteiro
   senha: caractere
   valor: real
inicio
   limpatela
   escreva("--- Transferência Bancária ---\n")
   
   escreva("Número da sua conta: ")
   leia(numContaOrigem)
   escreva("Senha: ")
   leia(senha)

   // 1. Autentica a Origem
   iOrigem <- autenticarUsuario(numContaOrigem, senha)
   
   se (iOrigem = 0) entao
      escreva("\n[ERRO] Conta de origem ou senha incorretos.\n")
      retorne
   fimse

   // 2. Encontra o Destino
   escreva("Número da conta destino: ")
   leia(numContaDestino)
   iDestino <- buscarContaPorNumero(numContaDestino)
   
   se (iDestino = 0) entao
      escreva("\n[ERRO] Conta de destino não encontrada.\n")
      retorne
   fimse
   
   // 3. Validação de Transferência para si mesmo
   se (iOrigem = iDestino) entao
      escreva("\n[ERRO] Não é possível transferir para a mesma conta.\n")
      retorne
   fimse

   // 4. Pede o Valor e Valida
   escreva("Valor da transferência: R$ ")
   leia(valor)
   
   se (valor <= 0) entao
      escreva("\n[ERRO] O valor da transferência deve ser positivo.\n")
   senao se (contas[iOrigem].saldo < valor) entao
      escreva("\n[ERRO] Saldo insuficiente para a transferência.\n")
   senao
      // 5. Executa a Transação
      contas[iOrigem].saldo <- contas[iOrigem].saldo - valor
      contas[iDestino].saldo <- contas[iDestino].saldo + valor
      
      // Registra nas duas contas
      registrarTransacao(iOrigem, "Transf. Enviada", valor, numContaDestino)
      registrarTransacao(iDestino, "Transf. Recebida", valor, numContaOrigem)
      
      escreva("\nTransferência de R$ ", valor:0:2, " realizada com sucesso!\n")
      escreva("De: ", contas[iOrigem].titular, "\n")
      escreva("Para: ", contas[iDestino].titular, "\n")
   fimse
fimprocedimento

// --- Procedimento: Consultar Saldo e Extrato ---
procedimento consultarSaldoEExtrato()
var
   numConta, indiceConta, j: inteiro
   senha: caractere
   t: Transacao // Variável auxiliar para facilitar a leitura
inicio
   limpatela
   escreva("--- Consulta de Saldo e Extrato ---\n")
   
   escreva("Número da conta: ")
   leia(numConta)
   escreva("Senha: ")
   leia(senha)

   indiceConta <- autenticarUsuario(numConta, senha)
   
   se (indiceConta = 0) entao
      escreva("\n[ERRO] Conta ou senha incorretos.\n")
   senao
      escreva("-----------------------------------------\n")
      escreva("Conta: ", contas[indiceConta].numeroConta, " | Titular: ", contas[indiceConta].titular, "\n")
      escreva("SALDO ATUAL: R$ ", contas[indiceConta].saldo:0:2, "\n")
      escreva("-----------------------------------------\n")
      escreva("Extrato de Transações (", contas[indiceConta].totalTransacoes, "):\n")
      
      se (contas[indiceConta].totalTransacoes = 0) entao
         escreva("  (Nenhuma transação registrada)\n")
      senao
         // Loop para exibir o extrato (usando o novo 'tipo Transacao')
         para j de 1 até contas[indiceConta].totalTransacoes faca
            t <- contas[indiceConta].transacoes[j] // Joga o registro em 't'
            
            escreva(" - ", t.tipoOp, " | R$ ", t.valor:0:2)
            
            // Se for transferência, mostra a conta relacionada
            se (t.contaRelacionada > 0) entao
               escreva(" | Conta: ", t.contaRelacionada)
            fimse
            escreval("") // Pula linha
            
         fimpara
      fimse
      escreva("-----------------------------------------\n")
   fimse
fimprocedimento

// --- Bloco Principal (Início da Execução) ---
inicio
   totalContas <- 0
   opcao <- -1
   
   // Menu principal
   repita
      limpatela
      escreva("=========================================\n")
      escreva("=       Simulador de Sistema Bancário       =\n")
      escreva("=========================================\n")
      escreva(" Contas Ativas: ", totalContas, "/", LIMITE_CONTAS, "\n")
      escreva("=========================================\n")
      escreva("1. Abrir Conta\n")
      escreva("2. Depósito\n")
      escreva("3. Saque\n")
      escreva("4. Transferência\n")
      escreva("5. Consulta de Saldo e Extrato\n")
      escreva("0. Sair\n")
      escreva("-----------------------------------------\n")
      escreva("Escolha uma opção: ")
      leia(opcao)

      escolha opcao
         caso 1
            abrirConta()
            Pausar()
         caso 2
            depositar()
            Pausar()
         caso 3
            sacar()
            Pausar()
         caso 4
            transferir()
            Pausar()
         caso 5
            consultarSaldoEExtrato()
            Pausar()
         caso 0
            escreva("\nSaindo do sistema... Obrigado!\n")
         padrão
            escreva("\n[ERRO] Opção inválida. Tente novamente.\n")
            Pausar()
      fimescolha
      
   até (opcao = 0)
fimalgoritmo
