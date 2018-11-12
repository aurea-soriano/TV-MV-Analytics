/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package classification;

import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.logging.Level;
import java.util.logging.Logger;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.LinearRegression;
import weka.core.FastVector;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

//import weka.classifiers.Evaluation;
//import weka.classifiers.trees.J48;
//import weka.core.Instances;
//import weka.core.converters.ConverterUtils;
/**
 *
 * @author aurea
 */
public class LinearRegressionRegression implements Classifier {

    Instances[] trainingSplits;
    Instances[] testingSplits;
    FastVector predictions;

    Lock lock = new java.util.concurrent.locks.ReentrantLock();

    @Override
    public String classify(String dataPath) {
        String resultClassifier = "Linear Regression \n\n";
        try {

            ConverterUtils.DataSource fonte = new ConverterUtils.DataSource(dataPath);
            Instances data = fonte.getDataSet();
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LinearRegression linearRegression = new LinearRegression();
            linearRegression.buildClassifier(data);
            resultClassifier += linearRegression.toString() + "\n";

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(linearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }

    @Override
    public String classify(Instances data) {
        String resultClassifier = "Linear Regression  \n\n";
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LinearRegression linearRegression = new LinearRegression();
            linearRegression.buildClassifier(data);
            resultClassifier += linearRegression.toString() + "\n";

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(linearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }
    
    
       public double[] classifyGetCoeff(Instances data) {
        String resultClassifier = "Linear Regression  \n\n";
        double[] coeff = null;
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LinearRegression linearRegression = new LinearRegression();
            linearRegression.buildClassifier(data);
            resultClassifier += linearRegression.toString() + "\n";
            coeff = linearRegression.coefficients();
            
           

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(linearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return coeff;
    }

    @Override
    public Instances[][] crossValidationSplit(Instances data, int numberOfFolds
    ) {
        Instances[][] split = new Instances[2][numberOfFolds];
        for (int i = 0; i < numberOfFolds; i++) {
            split[0][i] = data.trainCV(numberOfFolds, i);
            split[1][i] = data.testCV(numberOfFolds, i);
        }
        return split;
    }

    @Override
    public Evaluation classifyEvaluation(Instances trainingSet, Instances testingSet) {
        Evaluation evaluation = null;
        try {
            evaluation = new Evaluation(trainingSet);
            LinearRegression linearRegression = new LinearRegression();
            linearRegression.buildClassifier(trainingSet);
            evaluation.evaluateModel(linearRegression, testingSet);

        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return evaluation;

    }
    
     @Override
    public double resultClassify(Instances data) {
         double correlation = 0.0;
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            LinearRegression linearRegression = new LinearRegression();
            linearRegression.buildClassifier(data);
     

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(linearRegression, data, 10, new Random(1));
            correlation = crossVal.correlationCoefficient();

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return correlation;
    }
  public static void main(String[] args) {
        String filePath = "/home/aurea/MEGA/MEGA/Documento-Doctorado/Papers/SIBGRAPI2017/ResultsS1/original2.arff";
        LinearRegressionRegression linear = new LinearRegressionRegression();
        System.out.println(linear.classify(filePath));
    }
}
