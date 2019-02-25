//
//  HomeModel.swift
//  QurahApp
//
//  Created by netset on 7/16/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import UIKit
struct HomeModel {
    var categoryImage:UIImage!
    var categoryName:String!
}



struct ServicesData {
    var name:String!
    var serviceId:String!
    var price:Int!
}

struct ScheduleTiming {
    var startTime:String!
    var endTime:String!
    var appointmentTimeId : Int!
    var status : String!
}

struct ScheduleTimingInMillies {
    var startTime:Int!
    var endTime:Int!
}

