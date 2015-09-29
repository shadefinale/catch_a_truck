app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", function($scope, $stateParams, Restangular){

  //required hardcoding for map to load unless Restangular in resolve
  $scope.mapCenter = { latitude: 37.7833, longitude: -122.4167};

  $scope.map = {
    center: $scope.mapCenter,
    zoom: 13,
    markers: [$scope.mapCenter],
    markersEvents: {
      click: function(marker, eventName, model, arguments) {
        console.log(marker, eventName, model, arguments);
        $scope.map.window.model = model;
        $scope.map.window.show = true;
      }
    },
    window: {
      marker: {},
      show: false,
      closeClick: function() {
          this.show = false;
      },
      options: {} // define when map is ready
    }
  };

  $scope.status = {text : "Loading..."};

  Restangular.one("food_trucks").get({'address': $stateParams.query}).then(function(success){
    // debugger;
    console.log(success);
    $scope.map.markers = JSON.parse(success.markers);
    $scope.mapCenter.latitude = success.center.latitude;
    $scope.mapCenter.longitude = success.center.longitude;
    $scope.status.text = "";
  }, function(error){
    console.log(error);
    $scope.status.text = "Oops! There was an error. Try Again?";
  });

}]);
