""" [Tan2018](@cite) """
LifeCycleTan2018_θ_liq_ice(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 520.0
        FT(298.7)
    elseif z > 520.0 && z <= 1480.0
        FT(298.7) + (z - 520) * (FT(302.4) - FT(298.7)) / (1480 - 520)
    elseif z > 1480.0 && z <= 2000
        FT(302.4) + (z - 1480) * (FT(308.2) - FT(302.4)) / (2000 - 1480)
    elseif z > 2000.0
        FT(308.2) + (z - 2000) * (FT(311.85) - FT(308.2)) / (3000 - 2000)
    else
        FT(0)
    end)

""" [Tan2018](@cite) """
LifeCycleTan2018_q_tot(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 520
        (FT(17) + z * (FT(16.3) - FT(17.0)) / 520) / 1000
    elseif z > 520.0 && z <= 1480.0
        (FT(16.3) + (z - 520) * (FT(10.7) - FT(16.3)) / (1480 - 520)) / 1000
    elseif z > 1480.0 && z <= 2000.0
        (FT(10.7) + (z - 1480) * (FT(4.2) - FT(10.7)) / (2000 - 1480)) / 1000
    elseif z > 2000.0
        (FT(4.2) + (z - 2000) * (3 - FT(4.2)) / (3000 - 2000)) / 1000
    else
        FT(0)
    end)

""" [Tan2018](@cite) """
LifeCycleTan2018_u(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 700.0
        FT(-8.75)
    else
        FT(-8.75) + (z - 700) * (FT(-4.61) - FT(-8.75)) / (3000 - 700)
    end)
""" [Tan2018](@cite) """
LifeCycleTan2018_tke(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 2500.0
        FT(1) - z / 3000
    else
        FT(0)
    end)

""" TMP TKE profile for testing """
function LifeCycleTan2018_tke_prescribed(::Type{FT}) where {FT}
    z_in = FT[20.0, 60.0, 100.0, 140.0, 180.0, 220.0, 260.0, 300.0, 340.0, 380.0, 420.0, 460.0, 500.0,
              540.0, 580.0, 620.0, 660.0, 700.0, 740.0, 780.0, 820.0, 860.0, 900.0, 940.0, 980.0, 1020.0,
              1060.0, 1100.0, 1140.0, 1180.0, 1220.0, 1260.0, 1300.0, 1340.0, 1380.0, 1420.0, 1460.0,
              1500.0, 1540.0, 1580.0, 1620.0, 1660.0, 1700.0, 1740.0, 1780.0, 1820.0, 1860.0, 1900.0,
              1940.0, 1980.0, 2020.0, 2060.0, 2100.0, 2140.0, 2180.0, 2220.0, 2260.0, 2300.0, 2340.0,
              2380.0, 2420.0, 2460.0, 2500.0, 2540.0, 2580.0, 2620.0, 2660.0, 2700.0, 2740.0, 2780.0,
              2820.0, 2860.0, 2900.0, 2940.0, 2980.0]
    tke_in = FT[0.3216, 0.3469, 0.3570, 0.3442, 0.3285, 0.3168, 0.3072, 0.2935, 0.2611, 0.2014,
                0.1197, 0.0517, 0.0153, 0.0033, 0.0021, 0.0019, 0.0021, 0.0029, 0.0040, 0.0052,
                0.0065, 0.0078, 0.0092, 0.0106, 0.0119, 0.0130, 0.0138, 0.0142, 0.0140, 0.0131,
                0.0115, 0.0092, 0.0066, 0.0043, 0.0025, 0.0013, 0.0006, 0.0003, 0.0002, 0.0001,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0]
    not_type_stable_spline = Intp.interpolate((z_in, ), tke_in, Intp.Gridded(Intp.Linear()))
    return ZProfile(x -> FT(not_type_stable_spline(x)))
end

# Large-scale cooling
""" [Tan2018](@cite) """
LifeCycleTan2018_dTdt(::Type{FT}) where {FT} =
    ΠZProfile((Π, z) -> if z <= 1500.0
        FT(-2 / (3600 * 24)) * Π
    else
        FT(-2 / (3600 * 24) + (z - 1500) * (0 - -2 / (3600 * 24)) / (3000 - 1500)) * Π
    end)

# geostrophic velocity profiles
""" [Tan2018](@cite) """
LifeCycleTan2018_geostrophic_u(::Type{FT}) where {FT} =
    ZProfile(z -> -10 + FT(1.8e-3) * z)

""" [Tan2018](@cite) """
LifeCycleTan2018_geostrophic_v(::Type{FT}) where {FT} =
    ZProfile(z -> FT(0))

# Large-scale drying
""" [Tan2018](@cite) """
LifeCycleTan2018_dqtdt(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 300.0
        FT(-1.2e-8)   #kg/(kg * s)
    elseif z > 300.0 && z <= 500.0
        FT(-1.2e-8) + (z - 300) * (0 - FT(-1.2e-8)) / (500 - 300) #kg/(kg * s)
    else
        FT(0)
    end)

#Large scale subsidence
""" [Tan2018](@cite) """
LifeCycleTan2018_subsidence(::Type{FT}) where {FT} =
    ZProfile(z -> if z <= 1500.0
        FT(0) + z * (FT(-0.65) / 100 - 0) / (1500 - 0)
    elseif z > 1500.0 && z <= 2100.0
        FT(-0.65) / 100 + (z - 1500) * (0 - FT(-0.65) / 100) / (2100 - 1500)
    else
        FT(0)
    end)
