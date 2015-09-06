<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="testApp">
<head>
  <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
  <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<body ng-controller="myController">
  arahansa ! 
  
  <button ng-click="hello()">hihi</button>
  <script>
    $(document).ready(function(){
      $("#hi").val("hi");
    });
    
    var app = angular.module('testApp', []);
    app.controller('myController', function($scope){
      $scope.hello = function hello(){
        alert('hello');
      };
    });
    app.directive('myButton', function($compile){
      return {
        restrict: 'E',
        template: '<input type="text" />'
      };
    });
  </script>
</body>
  
</html>