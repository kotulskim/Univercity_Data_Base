package src;
import java.io.FileInputStream;
import java.io.*;
import java.sql.*;
import java.util.Random;
import java.util.Scanner;
import java.util.Properties;

import oracle.jdbc.pool.OracleDataSource; //sterownik bazy danych Oracle
import oracle.security.o3logon.a;

public class bdprojekt {
	Connection conn; // obiekt Connection do nawiazania polaczenia z baza danych

	public static void main(String[] args) {
		bdprojekt app = new bdprojekt();

		try {
			app.setConnection(); // otwarcie polaczenia z BD
			app.showStudents(); // test polaczenia
			app.showStudentsByCourse(); // wykonanie zapytania
			app.insertGrade(); // obsluga transakcji
			app.addGrade();
			app.closeConnection();// zamkniecie polaczenia z BD
		} 
		catch (SQLException eSQL) {
			System.out.println("Blad przetwarzania SQL " + eSQL.getMessage());
		}
		catch (IOException eIO) {
			System.out.println("Nie mozna otworzyc pliku" );
		}
	}

	public void setConnection() throws SQLException, IOException { // metoda nawiazuje polaczenie
		
		Properties prop = new Properties();
		FileInputStream in = new FileInputStream("connection.properties"); // w pliku znajduja sie parametry polaczenia
		prop.load(in); // zaczytanie danych z pliku properties
		in.close(); // zamkniecie pliku

		String host = prop.getProperty("jdbc.host");
		String username = prop.getProperty("jdbc.username");
		String password = prop.getProperty("jdbc.password");
		String port = prop.getProperty("jdbc.port");
		String serviceName = prop.getProperty("jdbc.service.name");

		String connectionString = String.format(
									"jdbc:oracle:thin:%s/%s@//%s:%s/%s",
									username, password, host, port, serviceName);

		System.out.println (connectionString);
		OracleDataSource ods; // nowe zrodlo danych (klasa z drivera  Oracle)
		ods = new OracleDataSource();

		ods.setURL(connectionString);
		conn = ods.getConnection(); // nawiazujemy polaczenie z BD

		DatabaseMetaData meta = conn.getMetaData();

		System.out.println("Polaczenie do bazy danych nawiaane.");
		System.out.println("Baza danych:" + " " + meta.getDatabaseProductVersion());
	}

	public void closeConnection() throws SQLException { // zamkniecie polaczenia
		conn.close();
		System.out.println("Polaczenie z baza zamkniete poprawnie.");
	}

	public void showStudents() throws SQLException {
		System.out.println("Lista studentów:");

		Statement stat = conn.createStatement(); // Statement przechowujacy polecenie SQL

		// wydajemy zapytanie oraz zapisujemy rezultat w obiekcie typu ResultSet
		ResultSet rs = stat.executeQuery("SELECT name, surname FROM students");

		System.out.println("---------------------------------");
		// iteracyjnie odczytujemy rezultaty zapytania
		while (rs.next())
			System.out.println(rs.getString(1) + " " + rs.getString(2));
		System.out.println("---------------------------------");

		rs.close();
		stat.close();
	}

	public void showStudentsByCourse() throws SQLException {
		System.out.println("Prepared statement:");

		// Zwoc uwage na znak zapytania w zapytaniu. W to miejsce zostanie
		// wstawiona wartosc wprowadzona przez uzytkownika
		PreparedStatement preparedStatement = conn
				.prepareStatement("SELECT name, surname FROM students WHERE cource = ?");

		System.out.println("Podaj Nazwę kursu:");
		Scanner in = new Scanner(System.in);

		preparedStatement.setString(1, in.nextLine());
		ResultSet rs = preparedStatement.executeQuery(); // Wykonaj zapytanie oraz zapamietaj zbior rezultatow

		System.out.println("---------------------------------");
		while (rs.next()) {
			System.out.println(rs.getString(1) + " " + rs.getString(2));		}
		System.out.println("---------------------------------");

		rs.close();
		preparedStatement.close();
	}

	public void insertGrade() throws SQLException {
		System.out.println("Obsluga transakcji");

		try {
			conn.setAutoCommit(false);

			Statement stat = conn.createStatement();
			int rsInt = stat.executeUpdate("UPDATE grades SET value = 5 where value = 4.5;");
			System.out.println("Liczba uaktualnionych wierszy: " + rsInt);
			conn.commit();
			stat.close();
		
		} catch (SQLException eSQL) {
			System.out.println("Transakcja wycofana");
			conn.rollback();
		}
	}

	public void addGrade() throws SQLException {
		System.out.println("dodanie oceny");
		CallableStatement callFunction = conn.prepareCall("{? = call add_grade(\'3,5\',987000,300,321023)}");
		callFunction.registerOutParameter(1, Types.INTEGER);
		callFunction.execute();
		System.out.println("dodano ocenę");
		callFunction.close();
	}
}
