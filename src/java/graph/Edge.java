/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package graph;

/**
 *
 * @author aurea
 */
public class Edge {
      double weight;
        int id;

        public Edge(double weight, int id) {
            this.id = id;
            this.weight = weight;
        }

        @Override
        public String toString() {
            return String.valueOf(id);
        }
}
