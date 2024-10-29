
data = dlmread('C:/.../.../.../iris_octave.csv', '');

% Déterminer le nombre de lignes
numRows = size(data, 1);

% Déterminer le nombre d'exemples d'entraînement
numTrain = round(0.8 * numRows);  

% Diviser les données en ensemble d'entraînement et de test
trainData = data(1:numTrain, :);  
testData = data(numTrain+1:end, :);  

% Paramètre k pour l'algorithme des k-plus proches voisins
k = 3;

% Préparer un vecteur pour stocker les prédictions
predictions = zeros(size(testData, 1), 1);

% Boucle pour prédire les classes des exemples de test
for i = 1:size(testData, 1)
    % Calculer les distances euclidiennes entre l'exemple de test et les exemples d'entraînement
    distances = sqrt(sum((trainData(:, 1:4) - testData(i, 1:4)).^2, 2));  
    
    % Trier les distances et obtenir les indices des k plus proches voisins
    [~, sorted_indices] = sort(distances);
    nearestNeighbors = trainData(sorted_indices(1:k), 5);  % Colonne 5 contient les labels de classe

    % Prédire la classe comme la classe majoritaire parmi les voisins les plus proches
    predictions(i) = mode(nearestNeighbors);
end

% Calculer l'accuracy
accuracy = sum(predictions == testData(:, 5)) / length(predictions) * 100;

% Afficher l'accuracy
fprintf('Accuracy: %.2f%%\n', accuracy);
