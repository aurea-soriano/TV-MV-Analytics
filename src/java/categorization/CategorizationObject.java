/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package categorization;

import java.util.ArrayList;
import static utils.Util.replaceStringOperators;

/**
 *
 * @author aurea
 */
public class CategorizationObject {

    String name;
    String description;
    String numberConditions;
    String numberClasses;
    ArrayList<Condition> listConditions;
    ArrayList<Float> listClasses;

    public CategorizationObject(String name, String description, String numberConditions, String numberClasses, ArrayList<Condition> listConditions) {
        this.name = name;
        this.description = replaceStringOperators(description);
        this.numberConditions = numberConditions;
        this.numberClasses = numberClasses;
        this.listConditions = listConditions;
        listClasses = new ArrayList<Float>();
        for (int i = 0; i < this.listConditions.size(); i++) {
            listClasses.add(i * 1.f);
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNumberConditions() {
        return numberConditions;
    }

    public void setNumberConditions(String numberConditions) {
        this.numberConditions = numberConditions;
    }

    public String getNumberClasses() {
        return numberClasses;
    }

    public void setNumberClasses(String numberClasses) {
        this.numberClasses = numberClasses;
    }

    public ArrayList<Condition> getListConditions() {
        return listConditions;
    }

    public void setListConditions(ArrayList<Condition> listConditions) {
        this.listConditions = listConditions;
    }

    public void addCondition(Condition condition) {
        this.listConditions.add(condition);
    }

    public ArrayList<Float> getListClasses() {
        return listClasses;
    }

    
    public float calculateClass(Float value) {
        float classValue = -1;
        for (int i = 0; i < this.listConditions.size(); i++) {
            float classTmp = this.listConditions.get(i).calculateClass(value);
            if (classTmp != -1) {
                classValue = classTmp;
                break;
            }
        }
        return classValue;
    }

}
