package com.diycomputerscience.minesweeper.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.diycomputerscience.minesweeper.Board;
import com.diycomputerscience.minesweeper.Point;
import com.diycomputerscience.minesweeper.RandomMineInitializationStrategy;
import com.diycomputerscience.minesweeper.Square;
import com.diycomputerscience.minesweeper.UncoveredMineException;

/**
 * Servlet implementation class MinwsweeperServe
 */
public class MinesweeperServe extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(MinesweeperServe.class);
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MinesweeperServe() {
        super();
        
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, 
						 HttpServletResponse response) 
								 throws ServletException, IOException {
		doPost(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, 
						  HttpServletResponse response) 
								  throws ServletException, IOException {
		logger.info("Control in doPost");
		String action = request.getParameter("action");
		try {
			if(action == null || action.equals("")) {
				startNewGame(request);
			} else if(action.equals("leftClick")) {
				leftClick(getRow(request), getCol(request), request);
			} else if(action.equals("rightClick")) {
				// Make these constants or enums
				rightClick(getRow(request), getCol(request), request);
			} else {
				error500();
			}			
		} catch(InputDataNotFoundException idnfe) {
			error500();
		} catch(UncoveredMineException ume) {
			request.setAttribute("gameOver", true);
		}
		displayBoard(request, response);		
	}
	
	private void displayBoard(HttpServletRequest request,
							  HttpServletResponse response) throws IOException, ServletException {
		request.getRequestDispatcher("game.jsp").forward(request, response);
	}

	private void error500() {
		// TODO Auto-generated method stub
		
	}

	private int getRow(HttpServletRequest request) throws InputDataNotFoundException {
		try {
			return Integer.valueOf(request.getParameter("row")); 			
		} catch(NumberFormatException nfe) {
			throw new InputDataNotFoundException("Input data for param 'row' not found");
		}		
	}

	private int getCol(HttpServletRequest request) throws InputDataNotFoundException {
		try {
			return Integer.valueOf(request.getParameter("col")); 			
		} catch(NumberFormatException nfe) {
			throw new InputDataNotFoundException("Input data for param 'row' not found");
		}
	}

	private void leftClick(int row, 
						   int col, 
						   HttpServletRequest request) throws UncoveredMineException {
		Board board = (Board)request.getSession().getAttribute("board");
		//TODO: If board is null then we should throw an IllegalActionException
		board.uncover(new Point(row, col));
	}

	private void rightClick(int row, int col, HttpServletRequest request) {
		Board board = (Board)request.getSession().getAttribute("board");
		//TODO: If board is null then we should throw an IllegalActionException
		board.mark(new Point(row, col));
	}

	private void startNewGame(HttpServletRequest request) {
		logger.info("Creating new Board");
		Board board= new Board(new RandomMineInitializationStrategy());
		logger.info(getBoardMines(board));
		request.getSession().setAttribute("board", board);
	}

	private String getBoardMines(Board board) {
		Square squares[][] = board.getSquares();
		StringBuffer buff = new StringBuffer();
		buff.append("Printing Board\n");
		for(int row=0; row<squares.length; row++) {
			for(int col=0; col<squares[row].length; col++) {
				if(squares[row][col].isMine()) {
					String template = "[%s,%s] isMine";
					buff.append(String.format(template, row, col) + "\n");
				}				
			}
		}
		return buff.toString();
	}
}
