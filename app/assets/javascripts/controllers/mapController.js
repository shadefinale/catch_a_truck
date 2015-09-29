app.controller("MapCtrl", ["$scope", "$stateParams", "Restangular", function($scope, $stateParams, Restangular){

  var errorMsg = "No Nearby Carts Open Today";

  //requesting info from backend
  var getCarts = function(query){
    Restangular.one("food_trucks").get({'address': query}).then(function(success){
      $scope.map.markers = JSON.parse(success.markers);
      console.log($scope.map.markers);
      $scope.mapCenter.latitude = success.center.latitude;
      $scope.mapCenter.longitude = success.center.longitude;
      $scope.map.zoom = query ? 15 : 13;
      updateStatusText();
    }, function(error){
      console.log(error);
      $scope.status.text = "Oops! There was an error. Try Again?";
    });
  };

  var updateStatusText = function(){
    if ($scope.map.markers.length == 0){
      $scope.status.text = errorMsg;
    } else {
      var cartNum = $scope.map.markers.length;
      $scope.status.text = cartNum + " Carts Nearby";
    }
  };

  var watchMapCenter = function(){
    $scope.$watch($scope.map.dragging, function(newCtr, oldCtr){
      console.log('center changed:', oldCtr, newCtr)
    } );
  };


  //initial page load
  getCarts($stateParams.query);

  $scope.status = {text : "Loading..."};

  //required hardcoding for map to load unless Restangular in resolve
  $scope.mapCenter = {id: 0, latitude: 37.7833, longitude: -122.4167};

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
      options: {}
    }
  };

  $scope.newQuery = function(){
    $scope.status.text = "Loading...";
    getCarts($scope.query);
  };

}]);
