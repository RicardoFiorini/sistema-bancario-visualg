algoritmo "Simulador de Sistema Bancário"
variáveis
    tipo ContaBancaria
        numeroConta : inteiro
        titular : caractere
        senha : caractere
        saldo : real
        transacoes : vetor[1..100] de caractere
        totalTransacoes : inteiro
    fimTipo

    contas : vetor[1..100] de ContaBancaria
    totalContas : inteiro
    opcao : inteiro
    numeroConta, contaDestino, i : inteiro
    senha, titular : caractere
    valor : real

início
    totalContas ← 0

    // Função para abrir uma nova conta
    funcao abrirConta()
        totalContas ← totalContas + 1
        escreva("Nome do titular: ")
        leia(contas[totalContas].titular)
        escreva("Crie uma senha para a conta: ")
        leia(contas[totalContas].senha)
        contas[totalContas].numeroConta ← 1000 + totalContas
        contas[totalContas].saldo ← 0
        contas[totalContas].totalTransacoes ← 0
        escreva("Conta aberta com sucesso! Número da conta: ", contas[totalContas].numeroConta, "\n")
    fimfuncao

    // Função para autenticar o usuário
    funcao autenticarUsuario(numero : inteiro, senhaEntrada : caractere) : inteiro
        para i de 1 até totalContas faça
            se contas[i].numeroConta = numero e contas[i].senha = senhaEntrada então
                retorne i
            fimse
        fimpara
        retorne 0 // Retorna 0 se a autenticação falhar
    fimfuncao

    // Função para registrar transações
    funcao registrarTransacao(indice : inteiro, descricao : caractere)
        se contas[indice].totalTransacoes < 100 então
            contas[indice].totalTransacoes ← contas[indice].totalTransacoes + 1
            contas[indice].transacoes[contas[indice].totalTransacoes] ← descricao
        fimse
    fimfuncao

    // Função para depositar
    funcao depositar()
        escreva("Número da conta para depósito: ")
        leia(numeroConta)
        escreva("Digite o valor do depósito: ")
        leia(valor)

        para i de 1 até totalContas faça
            se contas[i].numeroConta = numeroConta então
                contas[i].saldo ← contas[i].saldo + valor
                registrarTransacao(i, "Depósito de R$ " + valor)
                escreva("Depósito realizado com sucesso!\n")
                retorne
            fimse
        fimpara
        escreva("Conta não encontrada.\n")
    fimfuncao

    // Função para saque
    funcao sacar()
        escreva("Número da conta: ")
        leia(numeroConta)
        escreva("Senha: ")
        leia(senha)
        escreva("Valor do saque: ")
        leia(valor)

        i ← autenticarUsuario(numeroConta, senha)
        se i = 0 então
            escreva("Conta ou senha incorretos.\n")
        senão
            se contas[i].saldo >= valor então
                contas[i].saldo ← contas[i].saldo - valor
                registrarTransacao(i, "Saque de R$ " + valor)
                escreva("Saque realizado com sucesso!\n")
            senão
                escreva("Saldo insuficiente.\n")
            fimse
        fimse
    fimfuncao

    // Função para transferir
    funcao transferir()
        escreva("Número da sua conta: ")
        leia(numeroConta)
        escreva("Senha: ")
        leia(senha)
        escreva("Número da conta destino: ")
        leia(contaDestino)
        escreva("Valor da transferência: ")
        leia(valor)

        i ← autenticarUsuario(numeroConta, senha)
        se i = 0 então
            escreva("Conta ou senha incorretos.\n")
        senão
            se contas[i].saldo >= valor então
                para j de 1 até totalContas faça
                    se contas[j].numeroConta = contaDestino então
                        contas[i].saldo ← contas[i].saldo - valor
                        contas[j].saldo ← contas[j].saldo + valor
                        registrarTransacao(i, "Transferência de R$ " + valor + " para conta " + contaDestino)
                        registrarTransacao(j, "Recebimento de transferência de R$ " + valor + " da conta " + numeroConta)
                        escreva("Transferência realizada com sucesso!\n")
                        retorne
                    fimse
                fimpara
                escreva("Conta de destino não encontrada.\n")
            senão
                escreva("Saldo insuficiente.\n")
            fimse
        fimse
    fimfuncao

    // Função para consultar saldo e extrato
    funcao consultarSaldoEExtrato()
        escreva("Número da conta: ")
        leia(numeroConta)
        escreva("Senha: ")
        leia(senha)

        i ← autenticarUsuario(numeroConta, senha)
        se i = 0 então
            escreva("Conta ou senha incorretos.\n")
        senão
            escreva("Saldo atual: R$ ", contas[i].saldo, "\n")
            escreva("=== Extrato ===\n")
            para j de 1 até contas[i].totalTransacoes faça
                escreva(contas[i].transacoes[j], "\n")
            fimpara
        fimse
    fimfuncao

    // Menu principal
    repita
        escreva("\n=== Sistema Bancário ===\n")
        escreva("1. Abrir Conta\n")
        escreva("2. Depósito\n")
        escreva("3. Saque\n")
        escreva("4. Transferência\n")
        escreva("5. Consulta de Saldo e Extrato\n")
        escreva("0. Sair\n")
        escreva("Escolha uma opção: ")
        leia(opcao)

        escolha opcao
            caso 1
                abrirConta()
            caso 2
                depositar()
            caso 3
                sacar()
            caso 4
                transferir()
            caso 5
                consultarSaldoEExtrato()
            caso 0
                escreva("Saindo do sistema...\n")
            caso contrário
                escreva("Opção inválida. Tente novamente.\n")
        fimescolha
    até opcao = 0
fimalgoritmo
