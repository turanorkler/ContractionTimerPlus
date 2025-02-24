//
//  PopUp.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//

import SwiftUI

struct Pain: View {
    let title : String
    let action : (Int) -> Void
    
    @ObservedObject var constants = Constants.shared
    
    @State private var intensity : Int = 1
    @State private var selectedIntensity : Int = 1
        
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                VStack {
                    
                    Text("Please select the intensity".localized)
                        .font(.custom("Poppins-Light", size: 16))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            selectedIntensity = 1
                            //intensity = 1
                            self.intensity = 1
                        })
                        {
                            VStack {
                                Circle().fill(intensity < 1 ? .d9 : .b1)
                                    .background(
                                        selectedIntensity == 1 ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.black, lineWidth: 5)
                                                )
                                        ) : AnyView(Color.clear) // Arka plan için AnyView kullanıldı
                                    )
                                    .frame(width: 25, height: 25)
                                
                                Text("Slight")
                                    .font(.custom("Poppins-light", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        
                        Button(action: {
                            selectedIntensity = 2
                            self.intensity = 2
                        })
                        {
                            VStack {
                                Circle().fill(intensity < 2 ? .d9 : .b2)
                                    .background(
                                        selectedIntensity == 2 ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.black, lineWidth: 5)
                                                )
                                        ) : AnyView(Color.clear) // Arka plan için AnyView kullanıldı
                                    )
                                    .frame(width: 25, height: 25)
                             
                                Text("Easy")
                                    .font(.custom("Poppins-light", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            selectedIntensity = 3
                            self.intensity = 3
                        })
                        {
                            VStack {
                                Circle().fill(intensity < 3 ? .d9 : .b3)
                                    .background(
                                        selectedIntensity == 3 ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.black, lineWidth: 5)
                                                )
                                        ) : AnyView(Color.clear) // Arka plan için AnyView kullanıldı
                                    )
                                    .frame(width: 25, height: 25)
                                
                                Text("Medium")
                                    .font(.custom("Poppins-light", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            selectedIntensity = 4
                            self.intensity = 4
                        })
                        {
                            VStack {
                                Circle().fill(intensity < 4 ? .d9 : .b4)
                                    .background(
                                        selectedIntensity == 4 ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.black, lineWidth: 5)
                                                )
                                        ) : AnyView(Color.clear) // Arka plan için AnyView kullanıldı
                                    )
                                    .frame(width: 25, height: 25)
                                
                                Text("Rough")
                                    .font(.custom("Poppins-light", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            selectedIntensity = 5
                            self.intensity = 5
                        })
                        {
                            VStack {
                                Circle().fill(intensity < 5 ? .d9 : .b5)
                                    .background(
                                        selectedIntensity == 5 ? AnyView(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.black, lineWidth: 5)
                                                )
                                        ) : AnyView(Color.clear) // Arka plan için AnyView kullanıldı
                                    )
                                    .frame(width: 25, height: 25)
                                
                                Text("Painful")
                                    .font(.custom("Poppins-light", size: 12))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    Button(action: {
                        action(intensity)
                    }) {
                        Text("Save".localized)
                            .font(.custom("Poppins-Medium", size: 16))
                    }
                    .buttonStyle(.bordered)
                    .background(.greenradial1)
                    .foregroundColor(.white)
                    
                    .padding(.top,10)
                }
                .padding(20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(20)
            
                

                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
    }
}

#Preview {
    Pain(title: "Get Ready") { result in
        print(String(result))
    }
}
