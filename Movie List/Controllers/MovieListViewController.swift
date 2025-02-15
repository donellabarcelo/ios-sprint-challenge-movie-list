//
//  MovieListViewController.swift
//  Movie List
//
//  Created by Donella Barcelo on 11/8/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, MovieTableViewCellDelegate {
    
    var movies: [Movie] = []
    
    let movieController = MovieController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Table view setup and methods
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieController.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = movieController.movies[indexPath.row]
        cell.movie = movie
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movieController.deleteMovie(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // Cell delegate
    func isSeenButtonTapped(on cell: MovieTableViewCell) {
        guard let movie = cell.movie,
            let indexPath = tableView.indexPath(for: cell) else { return }
        
        movieController.toggleIsSeen(for: movie)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMovieModally" {
            guard let addMovieVC = segue.destination as? AddMovieViewController else { return }
            addMovieVC.movieController = movieController
        } else if segue.identifier == "editMovieSegue" {
            guard let editMovieVC = segue.destination as? EditMovieViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            editMovieVC.movieController = movieController
            editMovieVC.movie = movieController.movies[indexPath.row]
        }
    }
}

extension MovieListViewController: AddMovieDelegate {
    func movieWasCreated(_ movie: Movie) {
        
        movies.append(movie)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
