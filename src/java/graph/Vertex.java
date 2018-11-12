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
public class Vertex {

    String id;
    Integer code;
    

    public Vertex(String id, Integer code) {
        this.id = id;
        this.code = code;
    }

    @Override
    public String toString() {
        return id;
    }
    
    public Integer getCode(){
        return code;
    }
    
     public String getId(){
        return id;
    }
    
    
}
