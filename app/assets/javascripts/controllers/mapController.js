app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", 'mapData', function($scope, $stateParams, Restangular, mapData){

  if(mapData.error) $scope.status.text = "Oops! There seems to be an error. Please try again.";
  $scope.map.markers = JSON.parse(mapData.markers);
  $scope.mapCenter = mapData.center;
  // $scope.mapCenter.longitude = mapData.center.longitude;

  //required hardcoding for map to load unless Restangular in resolve
  // $scope.mapCenter = { latitude: 37.7833, longitude: -122.4167};

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

}]);
