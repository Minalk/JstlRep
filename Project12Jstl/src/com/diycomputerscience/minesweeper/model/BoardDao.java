package com.diycomputerscience.minesweeper.model;

import java.sql.Connection;

import com.diycomputerscience.minesweeper.Board;

public interface BoardDao {

	public Board load(Connection conn) throws PersistenceException;
	public void save(Connection conn, Board board) throws PersistenceException;
	public void delete(Connection conn) throws PersistenceException;
	
}
