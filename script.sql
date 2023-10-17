DO $$
DECLARE
	v_cod_cliente INT := 1; 
	v_cod_conta INT := 2;
	v_valor NUMERIC(10, 2) := 200;
	v_saldo_original NUMERIC(10, 2);
	v_saldo_resultante NUMERIC(10, 2);
BEGIN
	PERFORM fn_depositar(
		v_cod_cliente,
		v_cod_conta,
		v_valor,
		v_saldo_original,
		v_saldo_resultante
	);
	RAISE NOTICE 
	'Original %, Depositado %, Resultante %',
	v_saldo_original,
	v_valor,
	v_saldo_resultante;
	
EXCEPTION WHEN OTHERS THEN 
	RETURN;
END;
$$


-- DROP FUNCTION IF EXISTS fn_depositar; 
-- ROUTINE vale para functions e procedures
DROP ROUTINE IF EXISTS fn_depositar;
CREATE OR REPLACE FUNCTION fn_depositar(
	IN p_cod_cliente INT,
	IN p_cod_conta INT,
	IN p_valor NUMERIC (10, 2),
	OUT p_saldo_original NUMERIC (10, 2),
	OUT p_saldo_resultante NUMERIC (10, 2)
) RETURNS RECORD LANGUAGE plpgsql 
AS $$
BEGIN
	SELECT saldo FROM tb_conta c
	WHERE 
		c.conta_cliente = p_cod_cliente
		AND c.cod_conta = p_cod_conta
	INTO p_saldo_original;
	
	UPDATE tb_conta SET 
		saldo = saldo + p_valor
	WHERE cod_cleinte = p_cod_cliente 
	AND cod_conta = p_cod_conta;
	
	SELECT saldo FROM tb_conta c
	WHERE 
		c.conta_cliente = p_cod_cliente
		AND c.cod_conta = p_cod_conta
	INTO p_saldo_resultante;	
	RETURN;
EXCEPTION WHEN OTHERS THEN
	RETURN;
END;
$$

-- DO $$
-- DECLARE 
-- 	v_cod_cliente INT := 1;
-- 	v_saldo NUMERIC(10, 2) := 1500;
-- 	v_cod_tipo_conta INT := 1;
-- 	v_resultado BOOLEAN; 
-- BEGIN
-- 	SELECT fn_abrir_conta(
-- 		v_cod_cliente,
-- 		v_saldo,
-- 		v_cod_tipo_conta
-- 	) INTO v_resultado;
-- 	RAISE NOTICE 
-- 		'%', 
-- 		CASE WHEN 
-- 			v_resultado =TRUE THEN
-- 				'Conta foi aberta'
-- 			ELSE
-- 				'Conta não foi aberta'
-- 		END;
-- END;
-- $$


-- CREATE OR REPLACE FUNCTION fn_abrir_conta(
-- 	IN p_cod_cli INT, 
-- 	IN p_saldo NUMERIC(10, 2),
-- 	IN p_tipo_conta INT
-- ) RETURNS BOOLEAN LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	INSERT INTO tb_conta
-- 	(cod_cliente, saldo, cod_tipo_conta)
-- 	VALUES
-- 	($1, $2, $3);
-- 	RETURN TRUE;
-- EXCEPTION WHEN OTHERS THEN
-- 	RETURN FALSE;
-- END;
-- $$


-- CREATE TABLE tb_cliente(
-- cod_cliente SERIAL PRIMARY KEY,
-- nome VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_cliente (nome) VALUES ('João Santos'), ('Maria Andrade');
-- SELECT * FROM tb_cliente;
-- CREATE TABLE tb_tipo_conta(
-- cod_tipo_conta SERIAL PRIMARY KEY,
-- descricao VARCHAR(200) NOT NULL
-- );
-- INSERT INTO tb_tipo_conta (descricao) VALUES ('Conta Corrente'), ('Conta Poupança');
-- SELECT * FROM tb_tipo_conta;
-- CREATE TABLE tb_conta (
-- cod_conta SERIAL PRIMARY KEY,
-- status VARCHAR(200) NOT NULL DEFAULT 'aberta',
-- data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- data_ultima_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
-- saldo NUMERIC(10, 2) NOT NULL DEFAULT 1000 CHECK (saldo >= 1000),
-- cod_cliente INT NOT NULL,
-- cod_tipo_conta INT NOT NULL,
-- CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
-- tb_cliente(cod_cliente),
-- CONSTRAINT fk_tipo_conta FOREIGN KEY (cod_tipo_conta) REFERENCES
-- tb_tipo_conta(cod_tipo_conta)
-- );
-- SELECT * FROM tb_conta;

-- DO $$
-- DECLARE 
-- 	v_resultado BOOLEAN;
-- BEGIN 
-- 	SELECT
-- 		fn_algum('fn_eh_negativo', 1, 2 , 5, -1)
-- 	INTO v_resultado;
-- 	RAISE NOTICE '%', CASE WHEN v_resultado = TRUE THEN 'Sim, temm negativo' ELSE 'Não, não tem negativos' END;
-- END;
-- $$

-- [1, 2, 3, 4, 5, 6, 7, 1]
-- CREATE OR REPLACE FUNCTION fn_eh_negativo(
-- 	IN p_numero INT
-- ) RETURNS BOOLEAN
-- LANGUAGE plpgsql 
-- AS $$
-- BEGIN 
-- 	RETURN
-- 		CASE
-- 			WHEN p_numero < 0 
-- 				THEN TRUE ELSE FALSE
-- 		END;
-- END;
-- $$

-- CREATE OR REPLACE FUNCTION fn_algum(
-- 	IN p_fn_executa TEXT,  
-- 	VARIADIC p_elementos INT[]
-- ) RETURNS BOOLEAN
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
-- 	v_elemento INT;
-- 	v_resultado BOOLEAN;
-- BEGIN
-- 	FOREACH v_elemento IN ARRAY p_elementos LOOP
-- 		EXECUTE format( -- SELECT p_fn_executa(1)
-- 			'SELECT %s (%s)',
-- 			p_fn_executa,
-- 			v_elemento
-- 		) INTO v_resultado;
-- 		IF v_resultado = TRUE THEN
-- 			RETURN TRUE;
-- 		END IF;	
-- 	END LOOP;
-- 	RETURN FALSE;
-- END; 
-- $$

--chamando com bloco anônimo 
-- DO $$
-- DECLARE
-- 	v_resultado TEXT;
-- BEGIN
-- 	SELECT fn_hello() INTO v_resultado;
-- 	RAISE NOTICE '%', v_resultado;
-- 	-- v_resultado := fn_hello();
-- 	-- RAISE NOTICE '%', v_resultado;
-- 	-- executado e descartando o resultado 
-- 	-- PERFORM fn_hello();
-- 	--não pode, call somente para procs
-- 	--CALL fn_hello();
-- END; 
-- $$


-- CREATE OR REPLACE FUNCTION fn_hello()
-- RETURNS TEXT LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- RETURN 'Hello, functions';
-- END;
-- $$
-- --chamado sem bloco anônimo
-- --resultado é uma tabela
-- SELECT fn_hello();